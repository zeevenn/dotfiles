return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jsonls = {
        before_init = function(_, config)
          -- Append tsconfig schema after SchemaStore so it takes priority over "*.app.json"
          config.settings.json.schemas = config.settings.json.schemas or {}
          table.insert(config.settings.json.schemas, {
            fileMatch = { "tsconfig*.json" },
            url = "https://json.schemastore.org/tsconfig",
          })
        end,
      },
    },
  },
}
