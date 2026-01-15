-- Claude Code Integration

return {
  -- Diffview for reviewing changes
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = { default = { layout = "diff2_horizontal" } },
        keymaps = {
          view = { { "n", "q", "<cmd>DiffviewClose<cr>" } },
          file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>" } },
        },
      })
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
        render = "compact",
        stages = "fade",
        timeout = 3000,
      })
      vim.notify = notify
    end,
  },

  -- Auto-session
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
      })
      vim.keymap.set("n", "<leader>ss", "<cmd>SessionSearch<cr>", { desc = "Sessions" })
    end,
  },
}
