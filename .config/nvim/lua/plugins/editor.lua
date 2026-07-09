-- Transform to show relative path in preview title
local neotree_close_on_open = false

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
        transform = function(item)
          if item.hidden and not item.ignored then
            item.hidden = false
          end
        end,
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
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          neotree_close_on_open = true
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root(), reveal = true })
        end,
        desc = "Explorer NeoTree (auto-close)",
      },
      {
        "<leader>E",
        function()
          neotree_close_on_open = false
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root(), reveal = true })
        end,
        desc = "Explorer NeoTree (persistent)",
      },
    },
    opts = {
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            if neotree_close_on_open then
              neotree_close_on_open = false
              require("neo-tree.command").execute({ action = "close" })
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            neotree_close_on_open = false
          end,
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        group_empty_dirs = true,
        scan_mode = "deep",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_ignored = false,
          hide_hidden = false,
          never_show = { ".git", ".DS_Store" },
          never_show_by_pattern = { ".conform.*" },
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            untracked = "󰘥",
          },
        },
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
