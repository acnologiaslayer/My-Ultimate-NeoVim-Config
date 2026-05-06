-- ============================================================================
-- Core Neovim Options
-- ============================================================================

local opt = vim.opt
local g = vim.g

-- ============================================================================
-- Leader keys (must be set before lazy.nvim)
-- ============================================================================
g.mapleader = " "
g.maplocalleader = "\\"

-- ============================================================================
-- General
-- ============================================================================
opt.mouse = "a"                    -- Enable mouse in all modes
opt.clipboard = "unnamedplus"      -- Sync with system clipboard
opt.swapfile = false               -- No swap files
opt.backup = false                 -- No backup files
opt.undofile = true                -- Persistent undo
opt.undolevels = 10000
opt.confirm = true                 -- Confirm to save changes before exiting
opt.autowrite = true               -- Auto-save buffers
opt.updatetime = 200               -- Faster CursorHold events
opt.timeoutlen = 300               -- Faster which-key popup
opt.ttimeoutlen = 10
opt.shada = { "'10", "<0", "s10", "h" } -- Smaller shada file

-- ============================================================================
-- UI
-- ============================================================================
opt.number = true                  -- Show line numbers
opt.relativenumber = true          -- Relative line numbers
opt.signcolumn = "yes"             -- Always show sign column
opt.cursorline = true              -- Highlight current line
opt.termguicolors = true           -- True color support
opt.showmode = false               -- Don't show mode (statusline shows it)
opt.laststatus = 3                 -- Global statusline
opt.cmdheight = 1
opt.pumheight = 10                 -- Popup menu max height
opt.pumblend = 10                  -- Popup menu transparency
opt.winblend = 0
opt.scrolloff = 8                  -- Lines of context above/below cursor
opt.sidescrolloff = 8              -- Columns of context
opt.wrap = false                   -- No line wrapping
opt.linebreak = true               -- Wrap at word boundaries (when wrap is on)
opt.list = true                    -- Show invisible characters
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.splitright = true              -- Vertical splits open to the right
opt.splitbelow = true              -- Horizontal splits open below
opt.splitkeep = "screen"           -- Keep cursor position on split
opt.conceallevel = 2               -- For markdown/json
opt.concealcursor = ""

-- ============================================================================
-- Editing
-- ============================================================================
opt.expandtab = true               -- Spaces instead of tabs
opt.tabstop = 2                    -- 2 spaces per tab
opt.shiftwidth = 2                 -- 2 spaces for indentation
opt.softtabstop = 2
opt.smartindent = true             -- Smart auto-indenting
opt.autoindent = true
opt.breakindent = true             -- Indent wrapped lines
opt.shiftround = true              -- Round indent to multiple of shiftwidth

-- ============================================================================
-- Search
-- ============================================================================
opt.ignorecase = true              -- Case-insensitive search
opt.smartcase = true               -- ...unless capital letters used
opt.hlsearch = true                -- Highlight matches
opt.incsearch = true               -- Show matches as you type
opt.inccommand = "split"           -- Live preview substitutions
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- ============================================================================
-- Completion
-- ============================================================================
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- ============================================================================
-- Folding (using treesitter)
-- ============================================================================
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

-- ============================================================================
-- Performance
-- ============================================================================
opt.lazyredraw = false             -- Don't redraw during macros (false improves smooth scroll)
opt.synmaxcol = 240                -- Max syntax column
opt.redrawtime = 1500
opt.ttyfast = true

-- ============================================================================
-- Spell
-- ============================================================================
opt.spelllang = { "en" }
opt.spell = false

-- ============================================================================
-- Sessions
-- ============================================================================
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- ============================================================================
-- Cross-platform: Windows-specific shell setup
-- ============================================================================
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Use PowerShell on Windows if available; falls back gracefully
  if vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"
  elseif vim.fn.executable("powershell") == 1 then
    opt.shell = "powershell"
  end
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

-- ============================================================================
-- Disable unused built-in plugins for faster startup
-- ============================================================================
local disabled_built_ins = {
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
  "2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
  "matchit", "tutor_mode_plugin",
}
for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- ============================================================================
-- Diagnostic configuration
-- ============================================================================
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f00d}",
      [vim.diagnostic.severity.WARN]  = "\u{f071}",
      [vim.diagnostic.severity.INFO]  = "\u{f05a}",
      [vim.diagnostic.severity.HINT]  = "\u{f0eb}",
    },
  },
  underline = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = "if_many",
  },
})
