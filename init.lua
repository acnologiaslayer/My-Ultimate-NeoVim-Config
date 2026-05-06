-- ============================================================================
-- ArcVim
-- Cross-platform | Modern Features | AI-Driven Development
-- ============================================================================
-- Author: Built for boomershub
-- Requirements: Neovim 0.11+, git, a Nerd Font, ripgrep, fd, node, python3
-- ============================================================================

-- Load core configuration first (options, keymaps, autocmds)
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim plugin manager and load all plugins
require("config.lazy")
