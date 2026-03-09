-- Transform to show relative path in preview title
local function lsp_preview_title(item)
  if item.file then
    -- Show path relative to cwd, keeping last 3 directories
    item.preview_title = vim.fn.fnamemodify(item.file, ":~:.")
  end
  return item
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      -- Setup autocmd ONCE during plugin initialization (not in opts function)
      -- Refresh git status when focus returns to Neovim (e.g., after git commit)
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("snacks_explorer_git_refresh", { clear = true }),
        callback = function()
          -- Update all open explorers (will auto-refresh git status)
          local ok, snacks = pcall(require, "snacks")
          if ok and snacks.picker then
            local explorers = snacks.picker.get({ source = "explorer" })
            for _, picker in ipairs(explorers) do
              picker:action("explorer_update")
            end
          end
        end,
      })
    end,
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}

      -- Always show hidden files, exclude .git, .DS_Store and node_modules
      opts.picker.sources.files = {
        hidden = true,
        ignored = true,
        exclude = { "**/.git", "**/.DS_Store", "**/node_modules", "**/dist" },
      }

      opts.picker.sources.explorer = {
        hidden = true,
        ignored = true,
        exclude = {
          "**/.git",
          "**/.DS_Store",
          "**/.conform.*",
        },
        jump = { close = true },
      }

      -- Automatically open explorer in project directory
      -- In nvim start dashboard, open with projects pikcer
      opts.picker.sources.projects = {
        confirm = function(picker, item)
          picker:close()
          if item then
            vim.fn.chdir(item.file)
            Snacks.explorer()
          end
        end,
      }

      -- Show relative path in preview title for LSP sources
      opts.picker.sources.lsp_references = { transform = lsp_preview_title }
      opts.picker.sources.lsp_definitions = { transform = lsp_preview_title }
      opts.picker.sources.lsp_implementations = { transform = lsp_preview_title }
      opts.picker.sources.lsp_type_definitions = { transform = lsp_preview_title }

      return opts
    end,
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
      -- Custom explorer keymaps: e = quick (auto-close), E = persistent (stay open)
      {
        "<leader>e",
        function()
          Snacks.picker.pick("explorer", { jump = { close = true } })
        end,
        desc = "Explorer (auto-close)",
      },
      {
        "<leader>E",
        function()
          Snacks.picker.pick("explorer", { jump = { close = false } })
        end,
        desc = "Explorer (persistent)",
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
    event = "VeryLazy",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
    },
    config = function(_, opts)
      require("im_select").setup(opts)

      -- Switch to English on window/buffer switch
      -- Use Job API instead of system() to avoid blocking and memory buildup
      local im_group = vim.api.nvim_create_augroup("im_select_extra", { clear = true })
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
        group = im_group,
        callback = function()
          -- Use jobstart to avoid blocking and memory accumulation
          vim.fn.jobstart({ "macism", "com.apple.keylayout.ABC" }, {
            detach = true,
            on_exit = function() end,
          })
        end,
      })
    end,
  },

  -- Keep scrolloff at the end of file
  {
    "Aasim-A/scrollEOF.nvim",
    event = "BufReadPost",
    opts = {
      disabled_filetypes = {
        "snacks_terminal", -- Fix flickering in LazyGit and terminals
        "snacks_picker_list", -- Fix flickering in snacks.explorer
        "snacks_picker_input",
        "snacks_picker_preview",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_notif_history",
      },
    },
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mappings = {
          t = { j = { false } }, -- lazygit navigation fix
          v = { j = { k = false } }, -- visual select fix
        },
      })
    end,
  },
}
