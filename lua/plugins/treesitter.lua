-- ============================================================================
-- Treesitter (modern / main branch)
-- nvim-treesitter v1.0+ rewrote its API. There is no `nvim-treesitter.configs`
-- module here — install parsers via `require("nvim-treesitter").install()`,
-- and enable highlighting via a FileType autocmd that calls
-- `vim.treesitter.start()`. Folding is wired in `config/options.lua`.
-- Requires Neovim 0.12+ and tree-sitter CLI 0.26+.
-- ============================================================================

local ensure_installed = {
  -- Web
  "html", "css", "scss", "javascript", "typescript", "tsx", "vue", "svelte",
  "json", "yaml", "toml", "graphql", -- jsonc filetype falls back to json parser
  -- Backend / general
  "python", "go", "rust", "c", "cpp", "java", "kotlin", "ruby", "php",
  "lua", "luadoc", "luap", "vim", "vimdoc", "query",
  -- Shell / config
  "bash", "fish", "make", "cmake", "dockerfile", "ssh_config",
  "gitignore", "gitcommit", "git_config", "git_rebase", "diff",
  -- Markup / docs
  "markdown", "markdown_inline", "regex",
  -- Data
  "sql", "csv",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
    config = function()
      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end
          pcall(vim.treesitter.start, args.buf, lang)
        end,
      })
    end,
  },

  -- Textobjects: select / move / swap via tree-sitter queries
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- Built-in ftplugins define ]m / [m / ]M / [M etc. — disable to free those.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inner class" })
      vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Around argument" })
      vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Inner argument" })
      vim.keymap.set({ "x", "o" }, "al", function() select.select_textobject("@loop.outer", "textobjects") end, { desc = "Around loop" })
      vim.keymap.set({ "x", "o" }, "il", function() select.select_textobject("@loop.inner", "textobjects") end, { desc = "Inner loop" })

      -- Move
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class start" })
    end,
  },

  -- Sticky context: pin the current function/class header at the top while scrolling
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mode = "cursor",
      max_lines = 3,
      separator = nil,
    },
    keys = {
      { "<leader>ut", function() require("treesitter-context").toggle() end, desc = "Toggle treesitter context" },
    },
  },
}
