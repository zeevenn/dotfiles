return {
  -- Add catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      highlight_overrides = {
        mocha = function()
          return {
            -- ["@variable"] = { fg = "#bbd1ca" },
          }
        end,
      },
    },
  },

  -- Show almost full path
  -- https://github.com/LazyVim/LazyVim/discussions/3010#discussioncomment-13666237
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      for _, offset in ipairs(opts.options.offsets or {}) do
        if offset.filetype == "neo-tree" then
          offset.text = ""
        end
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({
        length = 6,
      }) }
    end,
  },

  -- Configure LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- Disable "No information available" message
        hover = {
          silent = true,
        },
      },
      presets = {
        lsp_doc_border = true,
        bottom_search = false,
      },
      -- Fix command-line message disappearing.
      -- see: https://github.com/folke/noice.nvim/issues/1097
      routes = {
        {
          view = "notify",
          filter = {
            event = "msg_show",
            kind = "shell_out",
          },
        },
        {
          opts = { skip = true },
          filter = {
            event = "notify",
            find = "unavailable: Condition failed",
          },
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        timeout = 10000,
      },
      indent = {
        scope = { enabled = false },
      },
      -- Disable scroll animations for better performance in low-end devices
      scroll = {
        -- enabled = false,
      },
      -- logo
      dashboard = {
        width = 80,
        pane_gap = 6,
        preset = {
          keys = {
            {
              icon = " ",
              key = "e",
              desc = "Explorer",
              action = function()
                require("neo-tree.command").execute({ dir = LazyVim.root(), reveal = true, position = "current" })
              end,
            },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███████╗███████╗███████╗██╗   ██╗███████╗███╗   ██╗███╗   ██╗
╚══███╔╝██╔════╝██╔════╝██║   ██║██╔════╝████╗  ██║████╗  ██║
  ███╔╝ █████╗  █████╗  ██║   ██║█████╗  ██╔██╗ ██║██╔██╗ ██║
 ███╔╝  ██╔══╝  ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██║╚██╗██║
███████╗███████╗███████╗ ╚████╔╝ ███████╗██║ ╚████║██║ ╚████║
╚══════╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝
]],
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Actions", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            limit = 4,
            indent = 2,
            padding = 1,
          },
          function()
            local git_root = Snacks.git.get_root()
            local in_git = git_root ~= nil
            local remote = ""
            if git_root then
              remote = vim.fn.system({ "git", "-C", git_root, "remote", "get-url", "origin" }):gsub("%s+$", "")
            end
            local is_github = remote:find("github%.com") ~= nil
            local is_gitlab = remote:find("gitlab") ~= nil
            local has_gh_notify = false
            if vim.fn.executable("gh") == 1 then
              vim.fn.system({ "gh", "notify", "-h" })
              has_gh_notify = vim.v.shell_error == 0
            end
            local cmds = {
              {
                title = "Notifications",
                cmd = "gh-notify-dashboard 5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key = "n",
                icon = " ",
                height = 5,
                enabled = is_github and has_gh_notify and vim.fn.executable("gh-notify-dashboard") == 1,
              },
              {
                title = "Open Issues",
                cmd = "gh issue list -L 3",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
                enabled = is_github and vim.fn.executable("gh") == 1,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
                enabled = is_github and vim.fn.executable("gh") == 1,
              },
              {
                title = "Open Issues",
                cmd = "glab issue list -P 3",
                key = "i",
                icon = " ",
                height = 7,
                enabled = is_gitlab and vim.fn.executable("glab") == 1,
              },
              {
                icon = " ",
                title = "Open MRs",
                cmd = "glab mr list -P 3",
                key = "P",
                height = 7,
                enabled = is_gitlab and vim.fn.executable("glab") == 1,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
    },
  },
}
