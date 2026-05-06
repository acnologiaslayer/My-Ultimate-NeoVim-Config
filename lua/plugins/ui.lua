-- ============================================================================
-- Colorscheme & UI Polish
-- ============================================================================

return {
  -- ==========================================================================
  -- Catppuccin colorscheme (primary)
  -- ==========================================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- Load before other plugins
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
        treesitter = true,
        notify = true,
        mini = { enabled = true },
        which_key = true,
        telescope = { enabled = true },
        mason = true,
        noice = true,
        lsp_trouble = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = false },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ==========================================================================
  -- Tokyonight (alternative)
  -- ==========================================================================
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- ==========================================================================
  -- Icons
  -- ==========================================================================
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- ==========================================================================
  -- Statusline
  -- ==========================================================================
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = "catppuccin-mocha", -- must match catppuccin `flavour` above
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics", symbols = { error = "\u{f00d} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f0eb} " } },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " \u{f111} ", readonly = " \u{f023}", unnamed = "[No Name]" } },
          },
          lualine_x = {
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            { "diff", symbols = { added = "\u{f067} ", modified = "\u{f111} ", removed = "\u{f068} " } },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function() return " " .. os.date("%R") end,
          },
        },
        extensions = { "neo-tree", "lazy", "trouble", "mason", "quickfix" },
      }
    end,
  },

  -- ==========================================================================
  -- Bufferline (tab-style buffer list)
  -- ==========================================================================
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned" },
      { "[B",         "<cmd>BufferLineMovePrev<CR>",             desc = "Move buffer prev" },
      { "]B",         "<cmd>BufferLineMoveNext<CR>",             desc = "Move buffer next" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" },
        },
        diagnostics_indicator = function(_, _, diag)
          local icons = { Error = "\u{f00d} ", Warn = "\u{f071} ", Info = "\u{f05a} " }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
      },
    },
  },

  -- ==========================================================================
  -- Notification system
  -- ==========================================================================
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      stages = "static",
      render = "compact",
    },
  },

  -- ==========================================================================
  -- Noice: better cmdline, messages, popupmenu
  -- ==========================================================================
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } } },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss notifications" },
    },
  },

  -- ==========================================================================
  -- Dashboard / Start screen
  -- ==========================================================================
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      -- ArcVim logo: large bird/wing art for wide terminals (123 cols × 70 lines)
      local big_logo = [==[
                                                                                          ░░        ▒
                                                                                          ██      ░█▒
                                                                                         ▓█▒▒    ▒██▒
                                                                                         ▓█▓░    ███▒     ▓▒
                                                                                         ███▓░  ▓▓██▒    ▓█▓
                                                                                        ▒▓██▓  ░ ▓█▓     ▒█▓
                                                                                       ░▓███▒░   ▓▓░    ░░▓░
                                          ░░                         ░▒▒▒░             ░▓▓▒░░  ▓▓     ░▓▓▒
                                        ▓▓                    ░▓█████▓                ▓▓▓▓    █▓▓░    ▓█▓░
                                      ██░                  ▓████▒             ░      ░ ▓█▓   ▓▓▓▓▒░  ░▓█▓     █░
                                    ▓███                ░███▒                 ░     ░  ▓▓    ░▓██▒░  ▓▓▓    ▓██
                                   ████               ▓██░                    ▒░   ░  ▓▓    ░ ▓█▓   ▒░     ░▓█░
                                 ░████              ▓█░                       ▓▓    ░▓▓   ░  ▒█▓ ▓█▓▓   ░ ▓░▒▓
                    ░            ▓███             ░▓                          ▓█   ░█▓      ▓▓░ ▓▓▓▒    ▓██▓░
                     ▒           ███                          ░▒▓███████████▓░▓█▓ ░▓█░  ▒█▓▓   ░▓▒     ▓███░   ░█
                     ░▒         ▓██                     █▓███████████████████████████   ░      ░  ░   ▒██▓░  ██▒
                      ▒░        ██                   ▓███████▓▒    ░▓███████▓▓███▓████▓▓      ░▓█▓▒  ░▒  ░░▒██▒
                       ▓░      ▒█▓          ▒      ░▓███▒      ▓█▓            ▓██ ░▓▓▓░    ░░░██▓▒▓█▓     ░██░
                    ░   ▓      ██        ▓▓       ████     ░▒                 ▒█▓ ▓▓░       ░██▓▓▓▓░    ▒▓▓░
                   ░▓    ▓     █  ░    ▓▓      ░█▓  █                          █▓ ▓     ░▒▓▓▓▓ ░   ▒▓▓███▓░
                   ▓▓     █   ░▓  ▓░ ▓█▓      ▓░   ▓                          ▓▓░░     ░▓         ░▒▓███▓▒▒▓█
                  ▓█░      █      ▒▓██▓▓          ░                         ░▓█▓        ░▓▒   ░▓█▓▒███▓▒▓█▓░
                 ░██▒       ▓     ▒███▓                        ░▒▓▓▓▓░░     ░█▓ ▒░   ░      ██▓▓▓▓  ░▓███▓
                 ▓██▓        ░   ▒███▓                 ▒    ░▓████████████▒░▓▓            ▒██▓▓██▓▒███▓
           ▒     ███▓            ███▓       ░        ██            ▒████████▓        ░▒░▓██▓  ▓███████░
             █   ███▓           ████▓     █▓      ░██▓                   ▓███▓                ░▓████████
               █░███▓    ▒░    ▒███    █▓█       ▒█▓   ▓▒█░░            ░   ▓▓▓▒        ▓▓▓▓█░  ▓ ▒█████▓
                 ███▓    ░▓▓▓█▒███▒   ███       ▓▓ ▓▓▓░  ▒█▓░▓██▓░     ▓▓  ▓▓▓░ ▓░   ░▒░ ░▓▓▓▓▓████▓▓████▓
       ▒▓██▒      ███      ▓▓ ▓███   ███              ▓▓▓  ▓▓   ▓█▓ ▓▒▓ ▓▓█▓▓█░ ▓▓▓███▓░▒▓▓░░▒▓▓▒    ░████░
      ░▓████▓  ▒▓░▓████▓▓▒░ ▓█▒████████    ░▓▓▒    ▒▓   ░░░  ░░░████  ▓█▓▓██████▒█▓▓▓▓▓▓███▓▓▓▓▒      ▒████
        ░  ▓████▓████░ ▓░  ▓▓▓██▓░░▓▓██▓▒░█▒▓▓▓    ▓░ ░░░░░░░     ░███    ░▓▓▒▒█▓▓███  ▒▒  ▒▓▓░░       ████▓
           ░░     ██▓░     ▓▓▒███▓▓▓░▓▓▓ ▒▓   ░░▒░░░▒░░░░▓▓▓▓▓░░     ░░▓  ▓░ ███  ▒██░                 ░████
▒  ▓▓▓▓▒                       █████▓▓▓▓░   ░▒▓▓██▓▓▓░░░▒▓  ▓▓▒▓░░    ░░███▒        ▒██████▓            ████
  ░  ▓████▓  ▒██▓█▓  ░░    ▓█▓ ▓█▓██▓▓▓▓▓▓▓▓▓▓▓█▓▒▒░▒▓██▓▓███▓░░░░░  ██████▓     ░▒   ▓██▓░▓▒           ▓███▓
     ░░       ░▓█▓       ▓█▓   ░▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▒▒▒▒▓▓▓███     ░███▓ ░▓█▒░█▒           ░░▒█▒           ▓▓██▓
            ░     ▒▓▓▓▓ ▓▓░▒  ▓█▓▓▓▓█████▓▓▓▓▓██▓▓▒▒▒▒ ░█▓███▓ ██████ ░████░░           ░█▒             ▒▓▓█▒░
    ░▒▓▒           ░▓▓▓▓▓██▓  ░░░▓▓▓███████▓▓▓▓▓▒▓▓▓▒▓▓ ▒      ░██▒░███   ░░                ░           ░░▓█ ▓
  ░▓██▒░▓▓████▓▒▒▓██▓▓█▓▒████████▓▓▓▓████▓██▓▓▓█▓▓▓▒▓▓▓▓   ░ ░░░░░ ░ ░░░▒██░▒            ▒█  ░▓░          ▓▓ █
    ▒  ▓▓    ░░░░  ░░  ▒▒░▓██▒ ░▓▓▓▓█████▓▓██▓▓▓█▓▓█▓█ ░  ░      ░▓▓▒ ░░░░░░░█                            ▓░▓▓
                ▓        ░█████▓▓████████▓█▓▓▓▓▓▓▓▓▓▓▓░░ ░         ▓░▒░░░ ░░░   ░▒                       ░███
                ▓█▓▓▓▒█▓█▓ ▒▓▒░░▓█▓▓███▓█▒▓▓▓▓▓▓▓▓▓░▓█           ▒     ░░░░    ▓███▓               █████████████░
         ░▓███▓  ▓█████▓  █▓ ▓███░▓█▒░░▒██▓▓█░▓█▓▓▓▓████▒       ░░   ██░░  ░▒  ░▓░██▓▓                 ▒██████████
            ░▒ ▒ ░▓██       ▓████▓ ░▓█▓▓████▓▓█▓ ░▓ ░███     ░░▒▓██ ███▒░░░░░██    ▒█▓░                 ███████████░
                  ░▓█████▓██▓█▓▓░▒▓██▓   █░▓▓██▓  ▓▓▓░        ▒▓░▓▓▓██░░░░░░░░▒▓ ██▒▓▓░                 █▓██████████░
                █▓▒▒▓▓████████▓▓██▓▓██  ▓██████▓█▓▓▓█░ █▒          ░███▒░▒▓░░   ▒ ▓▓▒   ▒             ▒▓    ░████████
             █▒       ▓▓█████████▓▒   ░▓▓▓▓░▓█▓   ▓▓█░              ▓▓░▒▓▒▒░░      ▒               ░▓▓▓▓▒▓▓▒▒████████
          ▓▓        ░▓    ░▓█▓             ░█▒░   ██▓      ░       ▓▒  ▒▓▒▒        ▓▓              ▓     ░▓█████████▓
        ▒░                         ░   ▒██▓▓     ▓███   ░▓▓▓▓▓     ▓░   ▒░         ▓ ▓▒                     ████████
                        ░████████▓░█░  ░▒▓      ▒██▓▓█▓▓▓▓ ░▒▒▒▓▓▒▒                  ░                      ▒█████████
                      ░▓██████▓▓▓▓█████░      ░▓███░ ▓█▓▓▓▓▓▓▓▓▒▓▓                  ░                       ▓██▓▓████████
              ▒███████████████▓▒▒▓██▒▒█▓▓█▓░░▓▓███▓▓▓▓▓█▓▒▒▒▒▒▒░                                            █▓ ░▓▓████████▓
            ▓▓█████▓▓████████▓▓░  ▓▓▓▓█▓░▒▓▓▓▓██▓▒░░░░░▒▓▓░                                               ░▒    ▒▓▓▓███████
           ░█████▓▓▒▒▒▓▓▓▓▒▒▒    ▓▓▓▒░█▓░░░▓▓▓▒░░░░                                                           ██ ░▓▓███████
          ░▓█████▓▒░            ░█▓▓░░█░░░░░ ░▒▒▓███            ░    ░                 ░                   ████   ▓███████▒
          ░▓████▓▓░            ▒▓███▓▒█       ░▓▒▓▓███▒      ░  ▒░░  ░                                 ░▒████░     ▒█████▓
          ▓▓▓▓████▒        ░▓▓████▓░░ ▓          ░░▒▓▓█████▓        ▓                                  ▒▓▓█▓        ░███░
         ░▓░  ▓████▓▒         ░▓▓▓░░░ ▓                                                                  ░█░        ░██
          ▓░    ░▓████         ▓▓▒░░▒ ▓     ░██                                                         ▒██▓        ▓▒
       ░▒  ░░ ██▓▒███░         ░▓▒░░▒▓▓      ███        ░▓▓▓▓▓▓▓▒░                                   ▒▓████▓       ░
        ▓▓░▓▓▓███████           ░▓▓░░▒▓▓▓░░ ░████░▒▒▓▓▒▓▓▒▒▒▒░░░▒▓▒▒      ░                        ▒▓▓██████
         ▓▓▓▓▓▓███████            ░▓▓▒▓▒▒▓▒▓█████▒▒▒▒▒▓▒░         ░▓       ▓▒                    ░▓████████▓
          ░▓▓▓█████████              ░▓▓▓▓▒▓████▓▓▒░          ░░   ▓        ▓▓▓░    ░▓░░    ░▒████████████▓
             ▒▓▓▓████████████▓▒░           ███░              ░░░░  ░          ▓█▓████████████████████████▒
                 ░░▓▓▓█████▒▓▒░          ░██▓                  ░░░░░░░          ▒▓█▓███████████████████▒
                     ░    ░▒░     ░  ░▓█████                    ░░   ░               ░░░░░░░▒▓█▓▓▓▓▓▒
                     ▒█▒░░░     ████████████░               ▒░ ░░░
                      ▒█████████████████████               ░░   ░▒
                        ▒█████████████████▒                ░     ░▒
                           ▓████████████▒                 ░░     ░
                              ░▒▓▓▓▒░
]==]

      -- Compact banner for narrow terminals
      local small_logo = [[
   █████╗ ██████╗  ██████╗██╗   ██╗██╗███╗   ███╗
  ██╔══██╗██╔══██╗██╔════╝██║   ██║██║████╗ ████║
  ███████║██████╔╝██║     ██║   ██║██║██╔████╔██║
  ██╔══██║██╔══██╗██║     ╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║  ██║██║  ██║╚██████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

      -- The big art is 123 cols wide × 70 lines tall.
      -- Use it only when the terminal can comfortably fit it; otherwise the compact banner.
      local cols, rows = vim.o.columns, vim.o.lines
      local header = (cols >= 130 and rows >= 80) and big_logo or small_logo

      return {
        bigfile    = { enabled = true },
        dashboard  = {
          enabled = true,
          preset = {
            header = header,
            keys = {
              { icon = "\u{f15b} ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
              { icon = "\u{f15c} ", key = "n", desc = "New File",        action = ":ene | startinsert" },
              { icon = "\u{f002} ", key = "g", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = "\u{f1da} ", key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = "\u{f013} ", key = "c", desc = "Config",          action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
              { icon = "\u{f1da} ", key = "s", desc = "Restore Session", section = "session" },
              { icon = "\u{f0cb2} ", key = "L", desc = "Lazy",            action = ":Lazy" },
              { icon = "\u{f00d} ", key = "q", desc = "Quit",            action = ":qa" },
            },
          },
        },
        indent     = { enabled = true },
        input      = { enabled = true },
        notifier   = { enabled = true, timeout = 3000 },
        quickfile  = { enabled = true },
        scroll     = { enabled = true },
        statuscolumn = { enabled = true },
        words      = { enabled = true },
        lazygit    = { enabled = true, configure = true },
      }
    end,
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse (open in browser)" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit current file history" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
    },
  },

  -- ==========================================================================
  -- Which-key: keymap discovery popup
  -- ==========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      icons = {
        rules = false,
      },
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find / File" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI / Toggle" },
        { "<leader>x", group = "Diagnostics / Quickfix" },
        { "<leader>a", group = "AI" },
        { "<leader>t", group = "Terminal / Test" },
        { "<leader>d", group = "Debug" },
        { "<leader><tab>", group = "Tabs" },
        { "[", group = "Previous" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
    },
  },

  -- ==========================================================================
  -- Indent guides
  -- ==========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble",
          "trouble", "lazy", "mason", "notify", "toggleterm",
          "lazyterm", "snacks_dashboard",
        },
      },
    },
  },
}
