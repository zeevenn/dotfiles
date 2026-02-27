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

-- Only use .git for root detection (default includes "lua" which causes nvim config to be detected as root)
vim.g.root_spec = { "lsp", ".git", "cwd" }

-- Open README on startup instead of dashboard.
-- Must live here (before lazy.setup) so vim.cmd.edit won't trigger plugin loading prematurely.
do
  local argc = vim.fn.argc(-1)
  local is_dir_arg = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
  local readme
  if argc == 0 or is_dir_arg then
    for _, name in ipairs({ "README.md", "readme.md", "README.MD", "README.txt", "README" }) do
      if vim.fn.filereadable(name) == 1 then
        readme = vim.fn.fnamemodify(name, ":p")
        break
      end
    end
  end
  if readme and argc == 0 then
    vim.api.nvim_buf_set_name(0, readme)
    vim.cmd.edit({ bang = true })
  elseif readme and is_dir_arg then
    -- vi . : let snacks open explorer + dashboard together, then swap dashboard → README
    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      once = true,
      callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "snacks_dashboard" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("edit " .. vim.fn.fnameescape(readme))
            return
          end
        end
      end,
    })
  end
end

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
