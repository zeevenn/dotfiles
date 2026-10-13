-- XmlIndentGet uses legacy syntax groups. Restore them after Treesitter starts,
-- since its highlighter clears the syntax option during the FileType event.
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "xml" then
    vim.bo[buf].syntax = "xml"
  end
end)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal syntax<"
