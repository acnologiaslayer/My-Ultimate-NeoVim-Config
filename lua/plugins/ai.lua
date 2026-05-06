-- ============================================================================
-- AI-Driven Development
--
-- Three complementary tools:
--   1. copilot.lua  – inline ghost-text autocompletion (GitHub Copilot)
--   2. avante.nvim  – Cursor-style sidebar with diff-apply (Claude/GPT/etc.)
--   3. CodeCompanion – conversational chat & inline assist with many providers
--
-- Pick the ones that fit your workflow. They're configured to coexist.
-- ============================================================================

return {
  -- ==========================================================================
  -- copilot.lua: ghost-text autocompletion (free for OSS / paid otherwise)
  -- Run :Copilot auth on first use.
  -- ==========================================================================
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },     -- We use blink.cmp/avante for menus
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true, -- Don't fight blink.cmp menu
        debounce = 75,
        keymap = {
          accept      = "<M-l>",  -- Alt+L (avoids Tab conflict with snippets/cmp)
          accept_word = "<M-w>",
          accept_line = "<M-j>",
          next        = "<M-]>",
          prev        = "<M-[>",
          dismiss     = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        yaml = true,
        ["."] = false,  -- Disable for unknown filetypes
      },
    },
  },

  -- ==========================================================================
  -- CopilotChat.nvim: chat interface for GitHub Copilot
  -- ==========================================================================
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatExplain", "CopilotChatReview", "CopilotChatFix", "CopilotChatOptimize", "CopilotChatTests" },
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4o",
      auto_insert_mode = true,
      window = {
        layout = "vertical",
        width = 0.4,
      },
      mappings = {
        complete = { insert = "<Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-r>", insert = "<C-r>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<CR>", desc = "Copilot chat (toggle)" },
      { "<leader>ae", "<cmd>CopilotChatExplain<CR>",  mode = { "n", "v" }, desc = "Explain code" },
      { "<leader>ar", "<cmd>CopilotChatReview<CR>",   mode = { "n", "v" }, desc = "Review code" },
      { "<leader>aF", "<cmd>CopilotChatFix<CR>",      mode = { "n", "v" }, desc = "Fix code" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "Optimize code" },
      { "<leader>at", "<cmd>CopilotChatTests<CR>",    mode = { "n", "v" }, desc = "Generate tests" },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Copilot Chat: ")
          if input ~= "" then vim.cmd("CopilotChat " .. input) end
        end,
        desc = "Quick chat",
      },
    },
  },

  -- ==========================================================================
  -- Avante.nvim: Cursor-style AI sidebar with diff apply
  -- Supports Claude / OpenAI / Gemini / Copilot as backend providers.
  -- ==========================================================================
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Avoid `*` here as version-pinning sometimes drifts
    build = "make",  -- On Windows: "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      -- Optional: if you want to view images in the chat
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      -- render-markdown.nvim is declared in misc.lua (lists "Avante" in its filetypes).
    },
    opts = {
      -- Default provider. Set ANTHROPIC_API_KEY for claude or OPENAI_API_KEY for openai.
      -- Change to "copilot" to reuse Copilot subscription instead of paying for an extra key.
      provider = "claude",
      mode = "agentic", -- "agentic" or "legacy"
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-opus-4-7",
          extra_request_body = {
            temperature = 0,
            max_tokens = 8000,
          },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o",
          extra_request_body = {
            temperature = 0,
            max_tokens = 8000,
          },
        },
        copilot = {
          model = "gpt-4o",
        },
      },
      behaviour = {
        auto_suggestions = false, -- Don't auto-trigger; copilot.lua handles ghost text
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        diff = {
          ours = "co", theirs = "ct", all_theirs = "ca",
          both = "cb", cursor = "cc", next = "]x", prev = "[x",
        },
        suggestion = {
          accept = "<M-CR>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = { next = "]]", prev = "[[" },
        submit = { normal = "<CR>", insert = "<C-s>" },
      },
      windows = {
        position = "right",
        wrap = true,
        width = 35,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
    },
    keys = {
      { "<leader>aA", "<cmd>AvanteAsk<CR>",     mode = { "n", "v" }, desc = "Avante: ask" },
      { "<leader>ac", "<cmd>AvanteChat<CR>",    mode = { "n", "v" }, desc = "Avante: chat" },
      { "<leader>ad", "<cmd>AvanteToggle<CR>",  desc = "Avante: toggle sidebar" },
      { "<leader>aE", "<cmd>AvanteEdit<CR>",    mode = { "v" },      desc = "Avante: edit selection" },
      { "<leader>ax", "<cmd>AvanteClear<CR>",   desc = "Avante: clear chat" },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<CR>", desc = "Avante: switch provider" },
    },
  },

  -- ==========================================================================
  -- CodeCompanion: conversational AI assistant — clean, powerful, multi-provider
  -- Use this if you prefer a simpler / lighter chat UI than Avante.
  -- ==========================================================================
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionToggle" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "anthropic" },     -- requires ANTHROPIC_API_KEY
        inline = { adapter = "anthropic" },
        agent = { adapter = "anthropic" },
      },
      display = {
        chat = {
          window = { layout = "vertical", width = 0.45 },
          show_settings = true,
        },
        diff = {
          enabled = true,
          provider = "default",
        },
      },
      opts = {
        log_level = "ERROR",
      },
    },
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
      { "<leader>aI", "<cmd>CodeCompanionActions<CR>",     mode = { "n", "v" }, desc = "CodeCompanion actions" },
      { "<leader>an", "<cmd>CodeCompanionChat Add<CR>",    mode = { "v" },       desc = "Add to CodeCompanion chat" },
    },
  },
}
