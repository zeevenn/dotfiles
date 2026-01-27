return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      disable_limit_reached_message = true,
      copilot_node_command = vim.fn.expand("~/.local/share/fnm/node-versions/v22.20.0/installation/bin/node"),
    },
  },

  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          enabled = true,
          backend = "tmux",
        },
        win = {
          split = {
            width = 60,
          },
        },
      },
      copilot = {
        status = {
          level = vim.log.levels.OFF,
        },
      },
    },
  },
}
