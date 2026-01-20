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

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
      },
    },
  },
}
