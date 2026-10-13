return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Use native indenters for these filetypes; keep Treesitter highlighting.
      indent = { disable = { "java", "html" } },
    },
  },
}
