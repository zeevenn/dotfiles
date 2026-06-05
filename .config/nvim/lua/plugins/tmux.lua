if not vim.env.TMUX then
  return {}
end

vim.system({ "tmux", "set", "status", "off" }, {}, function() end)

local augroup = vim.api.nvim_create_augroup("tmux_statusline", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  group = augroup,
  callback = function()
    vim.system({ "tmux", "set", "status", "off" }, {}, function() end)
  end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = augroup,
  callback = function()
    vim.system({ "tmux", "set", "status", "on" }, {}, function() end)
  end,
})

return {}
