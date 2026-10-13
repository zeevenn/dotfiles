-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable character hiding for readable
vim.opt.conceallevel = 0
vim.opt.autoread = true

-- Indent embedded HTML script/style bodies by one step with the native indenter.
vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"

-- This will cause buffer flickering in search
-- vim.o.scrolloff = 8

-- Enable project-local configuration files
vim.o.exrc = true
vim.opt.secure = true

-- Prefer the Git root for repo-wide tools in monorepos; fall back to LSP/cwd outside Git
vim.g.root_spec = { { ".git" }, "lsp", "cwd" }

-- Prettier: require config for most filetypes, but always enable for markdown
vim.g.lazyvim_prettier_needs_config = true

-- Treat .vscode/*.json files as jsonc (allows comments)
vim.filetype.add({
  pattern = {
    [".*%.vscode/.*%.json"] = "jsonc",
  },
})

-- Show diagnostic source in float window (e.g., "eslint:", "typescript:")
vim.diagnostic.config({
  float = {
    source = true,
  },
})
