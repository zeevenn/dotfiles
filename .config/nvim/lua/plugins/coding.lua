return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "css-lsp",
        "html-lsp", -- HTML LSP provides embedded CSS/JS completions
        "emmet-language-server", -- Emmet support backed by VS Code's Emmet integration
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local function in_raw_html_tag(tag)
        if vim.bo.filetype ~= "html" then
          return false
        end

        local row = vim.api.nvim_win_get_cursor(0)[1]
        local before = table.concat(vim.api.nvim_buf_get_lines(0, 0, row, true), "\n"):lower()
        local open = before:match(".*()<" .. tag .. "%f[%s>][^>]*>")
        local close = before:match(".*()</" .. tag .. ">")
        return open and (not close or open > close)
      end

      local function in_css_context()
        return vim.tbl_contains({ "css", "scss", "less" }, vim.bo.filetype) or in_raw_html_tag("style")
      end

      local function cursor_between_braces()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        return line:sub(col, col) == "{" and line:sub(col + 1, col + 1) == "}"
      end

      local function open_css_block(cmp)
        if not in_css_context() or not cursor_between_braces() then
          return
        end

        vim.schedule(function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()
          local before = line:sub(1, col)
          local after = line:sub(col + 1)
          local base_indent = line:match("^%s*") or ""
          local inner_indent = base_indent .. string.rep(" ", vim.fn.shiftwidth())

          vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
            before,
            inner_indent,
            base_indent .. after,
          })
          vim.api.nvim_win_set_cursor(0, { row + 1, #inner_indent })
          cmp.show({ providers = { "lsp" } })
        end)

        return true
      end

      opts.keymap = opts.keymap or {}
      opts.keymap["<CR>"] = { open_css_block, "accept", "fallback" }
    end,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>y", group = "yank/copy" },
        { "<leader>n", group = "npm/package" },
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
          local header = string.format("%s:%d\n", filepath, line)
          local messages = {}

          for i, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity]
            local source = diag.source or "unknown"
            local msg = diag.message
            if diag.code then
              msg = string.format("%s [%s]", msg, diag.code)
            end
            table.insert(messages, string.format("%d. [%s] (%s) %s", i, severity, source, msg))
          end

          local text = header .. table.concat(messages, "\n")
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
          local header = string.format("%s\n", filepath)
          local messages = {}

          for i, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity]
            local line = diag.lnum + 1
            local col = diag.col + 1
            local source = diag.source or "unknown"
            local msg = diag.message
            if diag.code then
              msg = string.format("%s [%s]", msg, diag.code)
            end

            table.insert(messages, string.format("%d. Line %d:%d [%s] (%s) %s", i, line, col, severity, source, msg))
          end

          local text = header .. table.concat(messages, "\n")
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

  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional for enhanced UI popups
    },
    opts = {
      fvm = true,
      debugger = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
    },
  },

  -- Show package versions in package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
      { "<leader>ns", "<cmd>lua require('package-info').show()<cr>", desc = "Show package info", ft = "json" },
      { "<leader>nc", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide package info", ft = "json" },
      { "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle package info", ft = "json" },
      { "<leader>nu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package", ft = "json" },
      { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete package", ft = "json" },
      { "<leader>ni", "<cmd>lua require('package-info').install()<cr>", desc = "Install package", ft = "json" },
      {
        "<leader>np",
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = "Change package version",
        ft = "json",
      },
    },
  },
}
