return {
  "folke/snacks.nvim",
  opts = {
    -- Use mini-indentscope instead
    indent = { enabled = false },

    picker = {
      sources = {
        -- Always show hidden files
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          -- Exclude conform.nvim's temporary files
          exclude = {
            "**/.conform.*",
          },
        },

        -- Automatically open explorer in project directory
        projects = {
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.fn.chdir(item.file)
              -- Restore session and open explorer
              local ok, persistence = pcall(require, "persistence")
              if ok then
                persistence.load()
              end
              Snacks.explorer()
            end
          end,
        },
      },
    },
  },
}
