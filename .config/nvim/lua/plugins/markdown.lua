return {
  -- Only render in Avante, not in regular markdown files
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "Avante" },
    },
  },

  -- Upload images to PicGo image bed
  {
    "askfiy/nvim-picgo",
    event = "VeryLazy",
    keys = {
      { "<leader>ip", "<cmd>UploadClipboard<cr>", desc = "Upload clipboard image (PicGo)" },
      { "<leader>if", "<cmd>UploadImagefile<cr>", desc = "Upload image file (PicGo)" },
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
            "-",
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        -- Override prettier for markdown to always run (ignore lazyvim_prettier_needs_config)
        prettier_markdown = {
          command = "prettier",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
        -- Forced to always run
        ["markdownlint-cli2"] = {
          condition = function()
            return true
          end,
          args = { "--config", vim.fn.stdpath("config") .. "/config/.markdownlint.json", "-" },
        },
        ["markdown-toc"] = {
          condition = function()
            return true
          end,
        },
      },
      formatters_by_ft = {
        -- Markdown: same as lazyvim markdown extra, but use prettier_markdown (always runs, no config check)
        markdown = { "prettier_markdown", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier_markdown", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },

  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "selimacerbas/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewRefresh", "MarkdownPreviewStop" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown: Preview" },
      { "<leader>mP", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown: Stop preview" },
      { "<leader>mr", "<cmd>MarkdownPreviewRefresh<cr>", desc = "Markdown: Refresh preview" },
    },
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      })
    end,
  },
}
