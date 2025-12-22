return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

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
      -- Use mini-indentscope instead
      indent = { enabled = false },
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
