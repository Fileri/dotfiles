-- Treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "VeryLazy" },
  cmd = { "TSUpdate", "TSInstall" },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", "css", "dockerfile", "go", "html", "javascript", "json",
        "lua", "markdown", "markdown_inline", "python", "rust",
        "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
