-- ============================================================================
-- Git integration
-- ============================================================================

return {
  -- ==========================================================================
  -- Gitsigns: signs in gutter, hunk navigation, blame
  -- ==========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end
        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, "Previous hunk")
        -- Actions
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>",   "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>",   "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer,        "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk,     "Undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer,        "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk,        "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis,            "Diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")
        -- Toggle
        map("n", "<leader>uG", gs.toggle_current_line_blame, "Toggle line blame")
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- ==========================================================================
  -- diffview: nicer diffs and merge conflict resolution
  -- ==========================================================================
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",         desc = "Open diffview" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>",        desc = "Close diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>",   desc = "Branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
    },
  },

  -- Note: lazygit is provided through snacks.nvim (see plugins/ui.lua):
  --   <leader>gg  – open lazygit
  --   <leader>gB  – open in browser
  --   <leader>gf  – lazygit log of current file
}
