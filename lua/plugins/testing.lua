-- ============================================================================
-- Testing: neotest + adapters
-- ============================================================================

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      -- Adapters (add more as needed)
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                                desc = "Run nearest test" },
      { "<leader>tT", function() require("neotest").run.run(vim.fn.expand("%")) end,              desc = "Run file tests" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end,                    desc = "Run all tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end,                           desc = "Run last test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                         desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                    desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end,                               desc = "Stop tests" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,            desc = "Debug nearest test" },
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, neotest_ns)

      require("neotest").setup({
        adapters = {
          require("neotest-jest")({ jestCommand = "npm test --" }),
          require("neotest-vitest"),
          require("neotest-python")({ runner = "pytest" }),
          require("neotest-go"),
          require("neotest-rust"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
      })
    end,
  },
}
