return {
  -- Add catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      highlight_overrides = {
        mocha = function()
          return {
            ["@variable"] = { fg = "#bbd1ca" },
          }
        end,
      },
    },
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
    },
  },

  -- logo
  {
    "snacks.nvim",
    opts = {
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
