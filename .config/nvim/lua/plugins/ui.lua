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
            NeoTreeGitUntracked = { link = "NonText" },
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
      local function count_text(lines)
        local count = 0
        local chars = 0
        for _, line in ipairs(lines) do
          -- Count Han characters individually, including supplementary ideographs.
          for _, char in ipairs(vim.fn.str2list(line, true)) do
            -- Exclude Unicode whitespace, including full-width spaces.
            local whitespace = (char >= 0x09 and char <= 0x0D)
              or char == 0x20
              or char == 0x85
              or char == 0xA0
              or char == 0x1680
              or (char >= 0x2000 and char <= 0x200A)
              or char == 0x2028
              or char == 0x2029
              or char == 0x202F
              or char == 0x205F
              or char == 0x3000
            if not whitespace then
              chars = chars + 1
            end
            if
              (char >= 0x3400 and char <= 0x4DBF)
              or (char >= 0x4E00 and char <= 0x9FFF)
              or (char >= 0xF900 and char <= 0xFAFF)
              or (char >= 0x20000 and char <= 0x3FFFF)
            then
              count = count + 1
            end
          end
          -- Count English words/numbers once; keep contractions together.
          local english = line:gsub("’", "'")
          for _ in english:gmatch("[A-Za-z0-9]+['-]?[A-Za-z0-9]*") do
            count = count + 1
          end
        end
        return { count = count, chars = chars }
      end
      local word_count = {}
      local text_filetypes = {
        [""] = true,
        markdown = true,
        ["markdown.mdx"] = true,
        text = true,
        rst = true,
        asciidoc = true,
        org = true,
        norg = true,
        tex = true,
        plaintex = true,
        typst = true,
        rmd = true,
        quarto = true,
        pandoc = true,
        vimwiki = true,
      }
      local selection_types = { v = "v", V = "V", ["\22"] = "\22", s = "v", S = "V", ["\19"] = "\22" }
      table.insert(opts.sections.lualine_y, 1, {
        function()
          local buf = vim.api.nvim_get_current_buf()
          local tick = vim.api.nvim_buf_get_changedtick(buf)
          if word_count.buf ~= buf or word_count.tick ~= tick then
            word_count = count_text(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
            word_count.buf = buf
            word_count.tick = tick
          end
          local selection_type = selection_types[vim.fn.mode()]
          if selection_type then
            local selected = count_text(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
              type = selection_type,
            }))
            return string.format(
              "选中 %d/%d 字 · %d/%d 字符",
              selected.count,
              word_count.count,
              selected.chars,
              word_count.chars
            )
          end
          return string.format("%d 字 · %d 字符", word_count.count, word_count.chars)
        end,
        cond = function()
          return vim.bo.buftype == "" and text_filetypes[vim.bo.filetype] == true
        end,
      })
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
                require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
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
