-- ============================================================================
-- lazy.nvim bootstrap and configuration
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Import all plugin specs from lua/plugins/
    { import = "plugins" },
  },
  defaults = {
    lazy = false,           -- Plugins load on startup unless they specify otherwise
    version = false,        -- Always use latest commit (set true for stable releases)
  },
  install = {
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,         -- Auto-check for plugin updates
    notify = false,         -- Don't spam notifications
    frequency = 86400,      -- Check once per day
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 90,
  },
})
