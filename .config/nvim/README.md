# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Project-local Configuration

You can create a `.nvim.lua` file in any project root to customize Neovim settings per project.

### ESLint LSP Configuration

For projects using `@antfu/eslint-config` or similar flat config,
you may need to extend ESLint LSP support for additional file types.

See: [ESLint Config - Neovim Format on Save](https://github.com/antfu/eslint-config?tab=readme-ov-file#neovim-format-on-save)

Example `.nvim.lua`:

```lua
local lspconfig = require("lspconfig")

lspconfig.eslint.setup({
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "html",
    "markdown",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "xml",
    "gql",
    "graphql",
    "astro",
    "svelte",
    "css",
    "less",
    "scss",
    "pcss",
    "postcss",
  },
  settings = {
    rulesCustomizations = {
      { rule = "style/*", severity = "off", fixable = true },
      { rule = "format/*", severity = "off", fixable = true },
      { rule = "*-indent", severity = "off", fixable = true },
      { rule = "*-spacing", severity = "off", fixable = true },
      { rule = "*-spaces", severity = "off", fixable = true },
      { rule = "*-order", severity = "off", fixable = true },
      { rule = "*-dangle", severity = "off", fixable = true },
      { rule = "*-newline", severity = "off", fixable = true },
      { rule = "*quotes", severity = "off", fixable = true },
      { rule = "*semi", severity = "off", fixable = true },
    },
  },
})
```

### Other Examples

#### Disable ESLint LSP completely for a project

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.lsp.stop_client(client.id)
    end
  end,
})
```

#### Disable ESLint for specific file types

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "less", "css", "scss" },
  callback = function()
    local clients = vim.lsp.get_active_clients({ name = "eslint" })
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id, true)
    end
  end,
})
```

#### Project-specific editor settings

```lua
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
```

#### Project-specific key mappings

```lua
vim.keymap.set("n", "<leader>pt", ":!npm test<CR>", { desc = "Run tests" })
```
