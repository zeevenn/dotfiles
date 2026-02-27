return {
  -- Add catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
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
      colorscheme = "catppuccin",
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
        preset = {
          header = [[
███████╗███████╗███████╗██╗   ██╗███████╗███╗   ██╗███╗   ██╗
╚══███╔╝██╔════╝██╔════╝██║   ██║██╔════╝████╗  ██║████╗  ██║
  ███╔╝ █████╗  █████╗  ██║   ██║█████╗  ██╔██╗ ██║██╔██╗ ██║
 ███╔╝  ██╔══╝  ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██║╚██╗██║
███████╗███████╗███████╗ ╚████╔╝ ███████╗██║ ╚████║██║ ╚████║
╚══════╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝
]],
        },
      },
    },
  },
}
