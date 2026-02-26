return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        -- Let eslint take over all formatting for JS/TS files (like VSCode)
        eslint = function()
          if not (vim.g.lazyvim_eslint_auto_format == nil or vim.g.lazyvim_eslint_auto_format) then
            return
          end

          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = true,
            priority = 200,
            filter = "eslint",
          })

          -- Markdown: use dedicated formatter (conform + eslint)
          local orig_sources = formatter.sources
          formatter.sources = function(buf)
            local ft = vim.bo[buf].ft
            if ft == "markdown" or ft == "markdown.mdx" then
              return {}
            end
            return orig_sources(buf)
          end

          LazyVim.format.register(formatter)

          -- Markdown: conform first, eslint fallback when attached
          LazyVim.format.register({
            name = "markdown: conform + eslint",
            primary = true,
            priority = 250,
            format = function(buf)
              require("conform").format({
                bufnr = buf,
                formatters = { "prettier_markdown", "markdownlint-cli2", "markdown-toc" },
              })
              if #vim.lsp.get_clients({ bufnr = buf, name = "eslint" }) > 0 then
                vim.lsp.buf.format({ bufnr = buf, filter = function(c) return c.name == "eslint" end })
              end
            end,
            sources = function(buf)
              local ft = vim.bo[buf].ft
              if ft ~= "markdown" and ft ~= "markdown.mdx" then
                return {}
              end
              local has_eslint = #vim.lsp.get_clients({ bufnr = buf, name = "eslint" }) > 0
              return has_eslint and { "conform", "eslint" } or { "conform" }
            end,
          })
        end,
      },
    },
  },
}
