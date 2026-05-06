-- ============================================================================
-- LSP: language servers via Mason + lspconfig
-- ============================================================================

return {
  -- ==========================================================================
  -- Mason: portable installer for LSPs, formatters, linters, debuggers
  -- ==========================================================================
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "black",
        "isort",
        "shfmt",
        -- Linters
        "eslint_d",
        "shellcheck",
        -- Debug adapters (DAP)
        "debugpy",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({ event = "FileType", buf = vim.api.nvim_get_current_buf() })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end
      if mr.refresh then mr.refresh(ensure_installed) else ensure_installed() end
    end,
  },

  -- ==========================================================================
  -- mason-lspconfig: bridge between mason and lspconfig
  -- ==========================================================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- ==========================================================================
  -- nvim-lspconfig: LSP client configurations
  -- ==========================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      -- Diagnostic config is handled in options.lua
      capabilities = {
        workspace = {
          fileOperations = { didRename = true, willRename = true },
        },
      },
      -- Servers and their configurations
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim", "Snacks" } },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlayHints = { enable = true },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        html = {},
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        bashls = {},
        dockerls = {},
        marksman = {},  -- Markdown
      },
    },
    config = function(_, opts)
      -- ============== Capabilities ==============
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      -- ============== On-attach: keymaps ==============
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local function nmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end

          nmap("gd", vim.lsp.buf.definition,        "Goto definition")
          nmap("gr", vim.lsp.buf.references,        "References")
          nmap("gI", vim.lsp.buf.implementation,    "Goto implementation")
          nmap("gy", vim.lsp.buf.type_definition,   "Goto type definition")
          nmap("gD", vim.lsp.buf.declaration,       "Goto declaration")
          nmap("K",  vim.lsp.buf.hover,             "Hover")
          nmap("<C-k>", vim.lsp.buf.signature_help, "Signature help")
          nmap("<leader>cr", vim.lsp.buf.rename,    "Rename")
          nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
          nmap("<leader>cR", function()
            if _G.Snacks and Snacks.rename then
              Snacks.rename.rename_file()
            else
              vim.lsp.buf.rename()
            end
          end, "Rename file")
          nmap("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
          end, "Toggle inlay hints")
        end,
      })

      -- ============== Set up servers via mason-lspconfig ==============
      local servers = opts.servers
      local ensure_installed = {}
      for name, _ in pairs(servers) do
        table.insert(ensure_installed, name)
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = true,
      })

      -- Configure each server using vim.lsp.config API (Neovim 0.11+)
      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end,
  },

  -- ==========================================================================
  -- Conform: formatting
  -- ==========================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format file/range",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = "Disable autoformat", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable autoformat" })
    end,
  },

  -- ==========================================================================
  -- nvim-lint: linters not provided by LSP
  -- ==========================================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function() pcall(lint.try_lint) end,
      })
    end,
  },
}
