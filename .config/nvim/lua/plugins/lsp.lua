return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      -- https://github.com/folke/lazydev.nvim/issues/136
      -- Fix global lua type undefined with lua_ls@3.17.1
      ensure_installed = { "lua_ls@3.16.4" },
    },
  },
}
