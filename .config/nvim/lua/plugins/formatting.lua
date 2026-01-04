return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        -- Register this to give eslint formatter lower priority and still format with vtsls as well.
        -- It can fix conflict between eslint and vtsls when using both.
        -- Eslint will override vtsls formatter.
        eslint = function()
          if not (vim.g.lazyvim_eslint_auto_format == nil or vim.g.lazyvim_eslint_auto_format) then
            return
          end

          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 0,
            filter = "eslint",
          })

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
      },
    },
  },
}
