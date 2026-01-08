-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable character hiding for readable
vim.opt.conceallevel = 0
vim.opt.autoread = true

-- This will cause buffer flickering in search
-- vim.o.scrolloff = 8

-- Enable project-local configuration files
vim.o.exrc = true
vim.opt.secure = true
