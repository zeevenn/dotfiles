-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

local function toggle_comment_insert()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local before = vim.api.nvim_get_current_line()
  vim.cmd.normal("gcc")
  local after = vim.api.nvim_get_current_line()

  -- Keep typing at the same text position when comment delimiters change.
  local content = vim.trim(before)
  local from = before:find(content, 1, true)
  local to = after:find(content, 1, true)
  if not to then
    content = vim.trim(after)
    from = before:find(content, 1, true)
    to = after:find(content, 1, true)
  end
  local offset = content ~= "" and from and to and (to - from) or 0
  cursor[2] = math.max(0, math.min(#after, cursor[2] + offset))
  vim.api.nvim_win_set_cursor(0, cursor)
end

-- Terminals may send Ctrl+/ as Ctrl+_.
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  pcall(keymap.del, "t", key)
  keymap.set("n", key, "gcc", { remap = true, desc = "Toggle Comment" })
  keymap.set("i", key, toggle_comment_insert, { desc = "Toggle Comment" })
  keymap.set("x", key, "gc", { remap = true, desc = "Toggle Comment" })
end

-- Fix space key occasionally acting as regular key
-- https://www.reddit.com/r/neovim/comments/1mcvzmi/lazyvim_space_key_occasionally_acts_as_regular/
keymap.set("n", " ", "<Nop>", { silent = true })

-- Open current file's directory in Finder
keymap.set("n", "<leader>fo", "<cmd>silent !open %:h<cr>", { desc = "Open in Finder" })

-- git open
keymap.set("n", "<leader>go", function()
  vim.cmd("!git open")
end, { desc = "Git Open (repo)" })
