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
      },
      formatters_by_ft = {
        markdown = { "prettier_markdown", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier_markdown", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },

  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "selimacerbas/markdown-preview.nvim",
    name = "selim-markdown-preview",
    cmd = { "MarkdownPreview", "MarkdownPreviewRefresh", "MarkdownPreviewStop" },
    keys = {
      {
        "<leader>cp",
        function()
          local mp = require("markdown_preview")
          if mp._server_instance then
            mp.stop()
          else
            mp.start()
          end
        end,
        ft = "markdown",
        desc = "Markdown Preview Toggle",
      },
    },
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      })

      -- Auto-stop preview when leaving markdown buffers for too long
      local preview_timer = nil
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("markdown_preview_cleanup", { clear = true }),
        pattern = "*",
        callback = function(ev)
          local mp = require("markdown_preview")
          if ev.match ~= "markdown" and mp._server_instance then
            -- Stop preview after 5 minutes of not viewing markdown
            if preview_timer then
              vim.fn.timer_stop(preview_timer)
            end
            preview_timer = vim.fn.timer_start(300000, function()
              if mp._server_instance then
                mp.stop()
                vim.notify("Markdown preview auto-stopped (inactive)", vim.log.levels.INFO)
              end
            end)
          elseif ev.match == "markdown" and preview_timer then
            vim.fn.timer_stop(preview_timer)
            preview_timer = nil
          end
        end,
      })
    end,
  },
}
