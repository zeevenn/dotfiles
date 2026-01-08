return {
  {
    "github/copilot.vim",
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
    },
  },
}
