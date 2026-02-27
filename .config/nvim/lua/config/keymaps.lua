-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- Fix space key occasionally acting as regular key
-- https://www.reddit.com/r/neovim/comments/1mcvzmi/lazyvim_space_key_occasionally_acts_as_regular/
keymap.set("n", " ", "<Nop>", { silent = true })

-- VScode style
keymap.set({ "n", "t" }, "<C-`>", function()
  Snacks.terminal()
end, { desc = "Switch to terminal" })

-- git open
keymap.set("n", "<leader>go", function()
  vim.cmd("!git open")
end, { desc = "Git Open (repo)" })
