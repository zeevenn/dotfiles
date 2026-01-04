-- Check if eslint config exists in project
local function has_eslint_config(bufnr)
  local eslint_configs = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" }
  return vim.fs.find(eslint_configs, { upward = true, path = vim.api.nvim_buf_get_name(bufnr) })[1] ~= nil
end

-- Return formatter config based on eslint availability
local function js_formatter(bufnr)
  if has_eslint_config(bufnr) then
    return { lsp_format = "first" }
  end
  return { lsp_format = "fallback" }
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = js_formatter,
        javascriptreact = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
        vue = js_formatter,
      },
    },
  },

  -- If eslint is found, disable vtsls formatting
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          on_attach = function(client, bufnr)
            vim.defer_fn(function()
              local has_eslint = #vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" }) > 0
              if has_eslint then
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end
            end, 100)
          end,
        },
      },
    },
  },
}
