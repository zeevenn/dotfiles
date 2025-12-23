return {
  -- Keep original symbol display
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/config/.markdownlint.json",
            "--",
          },
        },
      },
    },
  },
}
