-- Catppuccin Color Scheme

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        mason = true,
        native_lsp = { enabled = true },
        diffview = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
