return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>y", group = "yank/copy" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      -- Copy current line diagnostics
      {
        "<leader>yd",
        function()
          local line = vim.fn.line(".")
          local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
          if #diagnostics == 0 then
            vim.notify("No diagnostics on current line", vim.log.levels.INFO)
            return
          end

          local filepath = vim.fn.expand("%:.")
          local messages = {}

          for _, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity]
            table.insert(
              messages,
              string.format("%s:%d:%d [%s] %s", filepath, line, diag.col + 1, severity, diag.message)
            )
          end

          local text = table.concat(messages, "\n")
          vim.fn.setreg("+", text)
          vim.notify(string.format("Copied %d diagnostic(s) from line %d", #diagnostics, line), vim.log.levels.INFO)
        end,
        desc = "Copy line diagnostics",
      },

      -- Copy current buffer diagnostics
      {
        "<leader>yD",
        function()
          local diagnostics = vim.diagnostic.get(0)
          if #diagnostics == 0 then
            vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
            return
          end

          local filepath = vim.fn.expand("%:.")
          local messages = {}

          for _, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity]
            local line = diag.lnum + 1
            local col = diag.col + 1

            table.insert(messages, string.format("%s:%d:%d [%s] %s", filepath, line, col, severity, diag.message))
          end

          local text = table.concat(messages, "\n")
          vim.fn.setreg("+", text)
          vim.notify(string.format("Copied %d diagnostic(s) to clipboard", #diagnostics), vim.log.levels.INFO)
        end,
        desc = "Copy buffer diagnostics",
      },

      -- Copy current buffer relative path
      {
        "<leader>yp",
        function()
          local path = vim.fn.expand("%:.")
          if path == "" then
            vim.notify("No file path to copy", vim.log.levels.WARN)
            return
          end
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path, vim.log.levels.INFO)
        end,
        desc = "Copy relative path",
      },

      -- Copy current buffer absolute path
      {
        "<leader>yP",
        function()
          local path = vim.fn.expand("%:p")
          if path == "" then
            vim.notify("No file path to copy", vim.log.levels.WARN)
            return
          end
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path, vim.log.levels.INFO)
        end,
        desc = "Copy absolute path",
      },
    },
  },
}
