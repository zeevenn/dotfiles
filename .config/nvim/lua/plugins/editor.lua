return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Always show hidden files, exclude .git, .DS_Store and node_modules
          files = {
            hidden = true,
            ignored = true,
            exclude = { "**/.git", "**/.DS_Store", "**/node_modules" },
          },
          explorer = {
            hidden = true,
            ignored = true,
            exclude = {
              "**/.git",
              "**/.DS_Store",
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
    keys = {
      {
        "<leader><space>",
        LazyVim.pick("files", {
          cwd = LazyVim.root({ git = true }),
        }),
        desc = "Find Files (Root Dir)",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d %H:%M> • <summary>',
    },
  },

  -- Show git diff side by side
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
  },

  -- Keep scrolloff at the end of file
  -- {
  --   "Aasim-A/scrollEOF.nvim",
  --   event = { "CursorMoved", "WinScrolled" },
  --   opts = {
  --     insert_mode = true,
  --     disabled_filetypes = {
  --       "snacks_terminal", -- Fix flickering in LazyGit and terminals
  --     },
  --   },
  -- },
}
