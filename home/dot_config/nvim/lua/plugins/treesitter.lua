-- Treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  priority = 900,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash", "css", "dockerfile", "go", "html", "javascript", "json",
        "lua", "markdown", "markdown_inline", "python", "rust",
        "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true,
    })
    vim.treesitter.language.register("bash", "sh")
  end,
}
