-- ============================================================================
-- Debug Adapter Protocol (DAP)
-- ============================================================================

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      -- Language-specific adapters
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,           desc = "Continue / start" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,      desc = "Run to cursor" },
      { "<leader>dg", function() require("dap").goto_() end,              desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,          desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end,           desc = "Step out" },
      { "<leader>dO", function() require("dap").step_over() end,          desc = "Step over" },
      { "<leader>dp", function() require("dap").pause() end,              desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,        desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end,          desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,           desc = "Toggle DAP UI" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,   desc = "Widgets hover" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Mason-DAP: auto install adapters
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = { "python", "delve" },
        handlers = {},
      })

      -- DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Open/close UI on debug events
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

      -- Virtual text
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- Signs
      vim.fn.sign_define("DapBreakpoint",        { text = "●",  texthl = "DiagnosticError",   linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DiagnosticWarn",   linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",           { text = "▶",  texthl = "DiagnosticInfo",    linehl = "Visual", numhl = "" })
      vim.fn.sign_define("DapLogPoint",          { text = "■",  texthl = "DiagnosticInfo",    linehl = "", numhl = "" })

      -- Python
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      pcall(function()
        require("dap-python").setup(mason_path .. "/packages/debugpy/venv/bin/python")
      end)

      -- Go
      pcall(function() require("dap-go").setup() end)
    end,
  },
}
