-- ============================================================================
-- Core Keymaps (non-plugin)
-- Plugin-specific keymaps live in each plugin spec for clarity.
-- ============================================================================

local map = vim.keymap.set

-- ============================================================================
-- Quality of life
-- ============================================================================

-- Better up/down for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Save / quit
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })

-- ============================================================================
-- Window management
-- ============================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- ============================================================================
-- Buffer navigation
-- ============================================================================
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "[b",    "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b",    "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= current and vim.api.nvim_buf_is_loaded(b) then
      vim.api.nvim_buf_delete(b, { force = false })
    end
  end
end, { desc = "Delete other buffers" })

-- ============================================================================
-- Tab navigation
-- ============================================================================
map("n", "<leader><tab>n", "<cmd>tabnew<CR>",    { desc = "New tab" })
map("n", "<leader><tab>c", "<cmd>tabclose<CR>",  { desc = "Close tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<CR>",   { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprev<CR>",   { desc = "Previous tab" })

-- ============================================================================
-- Better indenting in visual mode (stay in mode)
-- ============================================================================
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<CR>==",     { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==",     { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv",     { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv",     { desc = "Move selection up" })

-- ============================================================================
-- Better paste / yank
-- ============================================================================
map("v", "p", '"_dP', { desc = "Paste without overwriting register" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- ============================================================================
-- Search and replace
-- ============================================================================
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search/replace word under cursor" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- ============================================================================
-- Better scrolling (centered)
-- ============================================================================
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- ============================================================================
-- Diagnostic navigation
-- ============================================================================
map("n", "]d", function() vim.diagnostic.jump({ count = 1 })  end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })  end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Previous error" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ============================================================================
-- File explorer fallback (will be overridden by neo-tree plugin)
-- ============================================================================
-- mapped under <leader>e in neo-tree plugin spec

-- ============================================================================
-- Terminal
-- ============================================================================
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Go to right window" })

-- ============================================================================
-- Misc
-- ============================================================================
map("n", "<leader>l", "<cmd>Lazy<CR>",  { desc = "Lazy plugin manager" })
map("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "Mason (LSP installer)" })
map("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle word wrap" })
map("n", "<leader>us", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle spell check" })
-- <leader>un is taken by Snacks (dismiss notifications); line-number toggle uses <leader>uL.
map("n", "<leader>uL", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })
