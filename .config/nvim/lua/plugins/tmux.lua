-- Embedded tmux status in lualine
if not vim.env.TMUX then
  return {}
end

vim.system({ "tmux", "set", "status", "off" }, {}, function() end)

vim.api.nvim_set_hl(0, "TmuxWindowActive", { fg = "#89b4fa", bold = true })
vim.api.nvim_set_hl(0, "TmuxWindowInactive", { fg = "#6c7086" })

local cache = {
  session = "",
  windows = {},
}

local function get_session()
  vim.system(
    { "tmux", "display-message", "-p", "#S" },
    { text = true },
    function(out)
      cache.session = out.stdout:gsub("[\n\r]", "")
    end
  )
  return " " .. cache.session
end

local function get_windows()
  vim.system(
    { "tmux", "list-windows", "-F", "#{window_index}:#{window_name}:#{window_active}" },
    { text = true },
    function(out)
      local windows = {}
      for line in out.stdout:gmatch("[^\r\n]+") do
        local idx, name, is_active = line:match("(%d+):([^:]*):(%d)")
        if idx and name then
          table.insert(windows, {
            text = idx .. ":" .. name,
            active = is_active == "1",
          })
        end
      end
      cache.windows = windows
    end
  )
  return cache.windows
end

local tmux_augroup = vim.api.nvim_create_augroup("tmux_statusline", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  group = tmux_augroup,
  callback = function()
    vim.system({ "tmux", "set", "status", "off" }, {}, function() end)
  end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = tmux_augroup,
  callback = function()
    vim.system({ "tmux", "set", "status", "on" }, {}, function() end)
  end,
})

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local tmux_session = function()
        return get_session()
      end

      local tmux_windows = function()
        local windows = get_windows()
        local parts = {}
        for _, win in ipairs(windows) do
          local hl = win.active and "%#TmuxWindowActive#" or "%#TmuxWindowInactive#"
          table.insert(parts, hl .. win.text)
        end
        return table.concat(parts, " ")
      end

      table.insert(opts.sections.lualine_x, 1, {
        tmux_session,
        color = { fg = "#a6e3a1", gui = "bold" },
        separator = "",
      })
      table.insert(opts.sections.lualine_x, 2, {
        tmux_windows,
        separator = "",
      })
    end,
  },
}
