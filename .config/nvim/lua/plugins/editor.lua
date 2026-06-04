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
      -- Workaround: snacks explorer git watcher doesn't reliably detect external
      -- git operations (known issue #1630/#2030). Use Tree:refresh(git_root) to
      -- force full tree + git cache invalidation.
      local function refresh_explorer_git()
        local ok, snacks = pcall(require, "snacks")
        if not ok or not snacks.picker then
          return
        end
        local Tree = require("snacks.explorer.tree")
        for _, picker in ipairs(snacks.picker.get({ source = "explorer" })) do
          if not picker.closed then
            local git_root = Snacks.git.get_root(picker:cwd()) or picker:cwd()
            Tree:refresh(git_root)
            picker.list:set_target()
            picker:find()
          end
        end
      end

      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("explorer_git_refresh", { clear = true }),
        callback = refresh_explorer_git,
      })

      vim.api.nvim_create_autocmd("TermClose", {
        group = vim.api.nvim_create_augroup("explorer_git_refresh_term", { clear = true }),
        callback = function(ev)
          if vim.api.nvim_buf_get_name(ev.buf):find("lazygit", 1, true) then
            vim.schedule(refresh_explorer_git)
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

      opts.picker.sources.grep = {
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
        -- Press / to toggle between input (search) and list (files)
        -- Press Esc in input to focus list instead of closing picker
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "toggle_focus", mode = { "i" } }, -- Esc moves to list instead of normal mode
            },
          },
        },
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

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("better_escape").setup({
        mappings = {
          t = { j = { false } }, -- lazygit navigation fix
          v = { j = { k = false } }, -- visual select fix
        },
      })
    end,
  },

  {
    "selimacerbas/live-server.nvim",
    opts = {
      default_port = 8000,
      live_reload = { enabled = true, inject_script = true, debounce = 120, css_inject = true },
      directory_listing = { enabled = true, show_hidden = false },
    },
    -- map to user commands (robust lazy-loading)
    keys = {
      { "<leader>ls", "<cmd>LiveServerStart<cr>", desc = "Start (pick path & port)" },
      { "<leader>lo", "<cmd>LiveServerOpen<cr>", desc = "Open existing port in browser" },
      { "<leader>lr", "<cmd>LiveServerReload<cr>", desc = "Force reload (pick port)" },
      { "<leader>lt", "<cmd>LiveServerToggleLive<cr>", desc = "Toggle live-reload (pick port)" },
      { "<leader>li", "<cmd>LiveServerStatus<cr>", desc = "Show server status" },
      { "<leader>lS", "<cmd>LiveServerStop<cr>", desc = "Stop one (pick port)" },
      { "<leader>lA", "<cmd>LiveServerStopAll<cr>", desc = "Stop all" },
    },
    config = function(_, opts)
      require("live_server").setup(opts)
    end,
  },
}
