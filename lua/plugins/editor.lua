-- ============================================================================
-- Editor: file explorer, fuzzy finder, navigation, text editing
-- ============================================================================

return {
  -- ==========================================================================
  -- Plenary (dependency for many plugins)
  -- ==========================================================================
  { "nvim-lua/plenary.nvim", lazy = true },

  -- ==========================================================================
  -- Neo-tree: file explorer
  -- ==========================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e",  "<cmd>Neotree toggle<CR>",                           desc = "File explorer" },
      { "<leader>fe", "<cmd>Neotree toggle<CR>",                           desc = "File explorer" },
      { "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer (cwd)" },
      { "<leader>ge", "<cmd>Neotree git_status<CR>",                       desc = "Git explorer" },
      { "<leader>be", "<cmd>Neotree buffers<CR>",                          desc = "Buffer explorer" },
    },
    deactivate = function() vim.cmd([[Neotree close]]) end,
    init = function()
      -- Open neo-tree if nvim was started on a directory
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then return end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "\u{f0da}", expander_expanded = "\u{f0d7}", expander_highlight = "NeoTreeExpander" },
      },
    },
  },

  -- ==========================================================================
  -- Telescope: fuzzy finder (still extremely popular & solid)
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        cond = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      -- find
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>",   desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",    desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",      desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",     desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope command_history<CR>", desc = "Command history" },
      { "<leader>fC", "<cmd>Telescope commands<CR>",     desc = "Commands" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",    desc = "Help" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",      desc = "Keymaps" },
      { "<leader>fm", "<cmd>Telescope marks<CR>",        desc = "Marks" },
      { "<leader>fR", "<cmd>Telescope registers<CR>",    desc = "Registers" },
      { "<leader>fT", "<cmd>Telescope colorscheme<CR>",  desc = "Colorscheme" },
      -- search
      { "<leader>sw", "<cmd>Telescope grep_string<CR>",  desc = "Search word under cursor" },
      { "<leader>sd", "<cmd>Telescope diagnostics<CR>",  desc = "Diagnostics" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>",          desc = "Document symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace symbols" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",  desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",   desc = "Git status" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
      -- resume
      { "<leader>fz", "<cmd>Telescope resume<CR>",       desc = "Resume last search" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "\u{f002} ",
          selection_caret = "\u{f0da} ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules/", "%.lock", "dist/", "build/", "target/", "%.o", "%.pyc" },
          layout_config = {
            horizontal = { preview_width = 0.55, prompt_position = "top" },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
          },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = function() return { "--hidden" } end },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },

  -- ==========================================================================
  -- Flash: enhanced motion / search (replaces hop, leap, etc.)
  -- ==========================================================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle flash search" },
    },
  },

  -- ==========================================================================
  -- Comment: smart commenting (also covered by mini.comment)
  -- ==========================================================================
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
  },

  -- ==========================================================================
  -- Surround: ys, ds, cs operations
  -- ==========================================================================
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local opts = {
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      }
      local mappings = {
        { opts.mappings.add,            desc = "Add surrounding",                  mode = { "n", "v" } },
        { opts.mappings.delete,         desc = "Delete surrounding" },
        { opts.mappings.find,           desc = "Find right surrounding" },
        { opts.mappings.find_left,      desc = "Find left surrounding" },
        { opts.mappings.highlight,      desc = "Highlight surrounding" },
        { opts.mappings.replace,        desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- ==========================================================================
  -- Auto pairs
  -- ==========================================================================
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- ==========================================================================
  -- Better text objects (ai/ii etc)
  -- ==========================================================================
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      }
    end,
  },

  -- ==========================================================================
  -- Trouble: prettier diagnostics, references, quickfix
  -- ==========================================================================
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",          desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",               desc = "Symbols" },
      { "<leader>xL", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP refs/defs" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                           desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                            desc = "Quickfix list" },
    },
  },

  -- ==========================================================================
  -- Todo comments: highlight & search TODO/FIX/etc.
  -- ==========================================================================
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>",                       desc = "Todo (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<CR>",                             desc = "Todo" },
    },
  },

  -- ==========================================================================
  -- Project-wide search/replace
  -- ==========================================================================
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sR",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "v" },
        desc = "Search & replace (grug-far)",
      },
    },
  },

  -- ==========================================================================
  -- Smart selection / incremental visual mode
  -- ==========================================================================
  {
    "kylechui/nvim-surround",
    enabled = false, -- using mini.surround instead
  },
}
