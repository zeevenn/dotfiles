return {
  -- Only render in Avante, not in regular markdown files
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "Avante" },
    },
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
