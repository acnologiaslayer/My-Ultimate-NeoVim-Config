-- ============================================================================
-- Misc useful plugins
-- ============================================================================

return {
  -- ==========================================================================
  -- Toggleterm: friendly terminal management (alongside Snacks terminal)
  -- ==========================================================================
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",      desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.4) end
      end,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },

  -- ==========================================================================
  -- Persistence: session management
  -- ==========================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
      { "<leader>qS", function() require("persistence").select() end,              desc = "Select session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save current session" },
    },
  },

  -- ==========================================================================
  -- Markdown rendering
  -- (Already declared as Avante dependency, but exposed here too for general use.)
  -- ==========================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante", "codecompanion" },
    opts = {
      file_types = { "markdown", "Avante", "codecompanion" },
      heading = { sign = false },
      code = { sign = false, width = "block", min_width = 45 },
    },
  },

  -- ==========================================================================
  -- Color preview (#ffaabb visualizer)
  -- ==========================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*", "!lazy" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
      },
    },
  },

  -- ==========================================================================
  -- Better escape: jk/jj as escape without delay
  -- ==========================================================================
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 250,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
      },
    },
  },

  -- ==========================================================================
  -- yanky: better yank/paste with history (use <leader>p to see ring)
  -- ==========================================================================
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua", optional = true },
    opts = {
      highlight = { timer = 150 },
    },
    keys = {
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, mode = { "n", "x" }, desc = "Open yank history" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle yank forward" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
    },
  },

  -- ==========================================================================
  -- Tmux navigation (Vim/Tmux pane sharing — only loads if tmux is in use)
  -- ==========================================================================
  {
    "christoomey/vim-tmux-navigator",
    cond = function() return vim.env.TMUX ~= nil end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },

  -- ==========================================================================
  -- DBee: database client (opt-in; loads only when called)
  -- ==========================================================================
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = { "Dbee" },
    build = function() require("dbee").install() end,
    keys = {
      { "<leader>D", function() require("dbee").toggle() end, desc = "Toggle DB UI" },
    },
    opts = {},
  },
}
