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
      -- Disable snacks.picker git diff keymaps (conflicts with diffview)
      { "<leader>gd", false },
      { "<leader>gD", false },
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
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
      { "<leader>gm", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diff against HEAD" },
      { "<leader>gM", "<cmd>DiffviewOpen main<cr>", desc = "Diff against main" },
    },
  },

  -- Auto switch input method
  {
    "keaising/im-select.nvim",
    opts = {},
  },

  -- Keep scrolloff at the end of file
  {
    "Aasim-A/scrollEOF.nvim",
    event = "BufReadPost",
    opts = {
      disabled_filetypes = {
        "snacks_terminal", -- Fix flickering in LazyGit and terminals
        "snacks_picker_list", -- Fix flickering in snacks.explorer
      },
    },
  },
}
