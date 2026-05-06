# ArcVim

A modern, modular, cross-platform Neovim setup with full IDE features and AI-driven development built in. Lazy-loaded for fast startup, organized so you can edit one plugin without breaking the rest.

## Features

- **Plugin manager**: `lazy.nvim` with automatic update checking and lockfile support
- **Completion**: `blink.cmp` (Rust-powered, much faster than nvim-cmp)
- **LSP**: Mason + nvim-lspconfig with sensible defaults for Lua, TS/JS, Python, Rust, Go, HTML/CSS, JSON/YAML, Bash, Docker, Markdown, and Tailwind
- **Syntax**: Treesitter with auto-install, smart text objects, sticky context
- **AI** (three complementary tools, pick what you like):
  - `copilot.lua` — ghost-text inline completion
  - `avante.nvim` — Cursor-style sidebar with diff-apply, supports Claude / GPT / Copilot / Gemini
  - `CodeCompanion` — clean conversational chat
  - `CopilotChat` — chat using your Copilot subscription
- **Git**: `gitsigns`, `diffview`, `lazygit` (via snacks.nvim)
- **Debugging**: `nvim-dap` + `nvim-dap-ui` with auto-installed adapters
- **Testing**: `neotest` with adapters for Jest, Vitest, Pytest, Go, Rust
- **Files & search**: `neo-tree`, `telescope` (with fzf-native), `flash` for motions
- **UI**: Catppuccin theme, lualine, bufferline, noice, snacks dashboard, which-key, indent guides
- **Quality of life**: yanky, better-escape, todo-comments, trouble, grug-far (search/replace), conform (format-on-save), nvim-lint, render-markdown, colorizer
- **Cross-platform**: Linux, macOS, Windows (PowerShell shell auto-configured)

## Requirements

| Tool         | Why                                  |
|--------------|--------------------------------------|
| **Neovim 0.11+** | required (uses `vim.lsp.config`, `vim.diagnostic.jump`) |
| `git`         | plugin manager + git plugins         |
| **A Nerd Font** | icons (e.g., JetBrainsMono Nerd Font) |
| `ripgrep` (`rg`) | telescope live grep                |
| `fd`          | fast file finding                    |
| `node` ≥ 20   | Copilot, eslint_d, prettier, ts_ls   |
| `python3`     | pyright, debugpy                     |
| `make` + C compiler | builds telescope-fzf-native, blink.cmp matcher, avante |
| `lazygit`     | for `<leader>gg` git UI              |

## Installation

### 1. Back up your existing config

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak  # plugin data
mv ~/.local/state/nvim ~/.local/state/nvim.bak  # state
mv ~/.cache/nvim      ~/.cache/nvim.bak         # cache
```

On Windows (PowerShell):

```powershell
Move-Item $env:LOCALAPPDATA\nvim       $env:LOCALAPPDATA\nvim.bak
Move-Item $env:LOCALAPPDATA\nvim-data  $env:LOCALAPPDATA\nvim-data.bak
```

### 2. Drop this config into place

```bash
# macOS / Linux
cp -r nvim-config ~/.config/nvim

# Windows
xcopy /E /I nvim-config %LOCALAPPDATA%\nvim
```

### 3. Launch Neovim

```bash
nvim
```

`lazy.nvim` will bootstrap itself, then install every plugin. Treesitter parsers and Mason tools (LSPs / formatters / debug adapters) install automatically on first open. Restart once everything finishes.

### 4. AI provider setup

Set the API key for whichever providers you want. Add to your shell rc file:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."   # for Avante (claude) and CodeCompanion
export OPENAI_API_KEY="sk-..."           # for Avante (openai)
```

For GitHub Copilot, run `:Copilot auth` once inside Neovim and follow the device-flow link.

To switch Avante's backend at runtime: `<leader>ap`.

## Health check

After installation:

```vim
:checkhealth
:Lazy
:Mason
```

## Keymap cheatsheet

Leader is `<Space>`.

### Files & search
| Keys | Action |
|---|---|
| `<leader><space>` / `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fk` | Keymaps |
| `<leader>e`  | Toggle file explorer |
| `<leader>sR` | Project-wide search/replace |
| `s` (normal/visual) | Flash jump |

### Code (LSP)
| Keys | Action |
|---|---|
| `gd` / `gr` / `gI` / `gy` | Go to definition / references / impl / type def |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file/range |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next / previous diagnostic |

### Git
| Keys | Action |
|---|---|
| `<leader>gg` | Lazygit |
| `<leader>gd` | Diffview open |
| `<leader>gh` | File git history |
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |

### AI
| Keys | Action |
|---|---|
| `<M-l>` (insert) | Accept Copilot ghost-text suggestion |
| `<leader>aa` | CopilotChat toggle |
| `<leader>aA` | Avante: ask |
| `<leader>ac` | Avante: chat |
| `<leader>ad` | Avante: toggle sidebar |
| `<leader>aE` (visual) | Avante: edit selection |
| `<leader>ai` | CodeCompanion chat |
| `<leader>ae` (visual) | Explain code |
| `<leader>aF` (visual) | Fix code |
| `<leader>at` (visual) | Generate tests |

### Debug
| Keys | Action |
|---|---|
| `<leader>db` / `<leader>dB` | Toggle / conditional breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step into / out / over |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |

### Test
| Keys | Action |
|---|---|
| `<leader>tt` | Run nearest |
| `<leader>tT` | Run file |
| `<leader>ta` | Run all |
| `<leader>ts` | Toggle test summary |
| `<leader>td` | Debug nearest |

### Window / buffer
| Keys | Action |
|---|---|
| `<C-h/j/k/l>` | Navigate windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>-` / `<leader>\|` | Horizontal / vertical split |

### Toggles
| Keys | Action |
|---|---|
| `<leader>uw` | Word wrap |
| `<leader>us` | Spell check |
| `<leader>uL` | Line numbers |
| `<leader>un` | Dismiss notifications |
| `<leader>uG` | Git blame line |
| `<leader>ut` | Treesitter context |
| `<leader>ch` | Inlay hints |

Press `<leader>` and wait — `which-key` will show all groups.

## Customization

### Add or remove a plugin

Plugins live in `lua/plugins/`. Each file returns a list of `lazy.nvim` specs. To add a plugin, drop a new `.lua` file there or append to an existing one. Lazy auto-imports everything in this directory, so no central registry to update.

### Change the colorscheme

Open `lua/plugins/ui.lua`, find the `catppuccin/nvim` block, change `flavour`, or replace the `vim.cmd.colorscheme(...)` line. `tokyonight` is also installed and ready to switch to.

### Disable a plugin you don't want

Add `enabled = false` to its spec, or delete the file. Examples of safely-removable groups:

- `lua/plugins/dap.lua` — if you never debug
- `lua/plugins/testing.lua` — if you don't need neotest
- `lua/plugins/ai.lua` — if you don't want AI integrations (or remove just the providers you don't use)

### Disable format-on-save

`:FormatDisable` (whole session) or `:FormatDisable!` (current buffer only). Re-enable with `:FormatEnable`.

## Troubleshooting

- **Icons look like boxes** → install a Nerd Font and configure your terminal to use it.
- **`blink.cmp` not completing fast** → ensure `cargo` is installed; the Rust matcher will fall back to Lua otherwise.
- **`avante.nvim` build fails** → `cd ~/.local/share/nvim/lazy/avante.nvim && make`. On Windows, run the included `Build.ps1`.
- **Treesitter parser errors after update** → `:TSUpdate` then restart.
- **Slow startup** → `:Lazy profile` shows what each plugin costs.
- **Copilot not suggesting** → `:Copilot status` to verify auth and node service.

## Layout

```
~/.config/nvim/
├── init.lua                   ← entry point
└── lua/
    ├── config/
    │   ├── options.lua        ← vim options & diagnostics
    │   ├── keymaps.lua        ← non-plugin keymaps
    │   ├── autocmds.lua       ← autocommands
    │   └── lazy.lua           ← plugin manager bootstrap
    └── plugins/
        ├── ui.lua             ← colorscheme, statusline, dashboard, which-key
        ├── editor.lua         ← neo-tree, telescope, flash, mini.*, trouble
        ├── treesitter.lua     ← syntax highlighting
        ├── lsp.lua            ← Mason + LSP servers + format/lint
        ├── completion.lua     ← blink.cmp
        ├── ai.lua             ← copilot, avante, codecompanion, copilot-chat
        ├── git.lua            ← gitsigns, diffview
        ├── dap.lua            ← debug adapter
        ├── testing.lua        ← neotest
        └── misc.lua           ← terminal, sessions, yanky, etc.
```

Each plugin file is self-contained — change one without touching the rest.
