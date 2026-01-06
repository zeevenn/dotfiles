return {
  {
    "yetone/avante.nvim",
    enabled = false,
    opts = {
      provider = "bedrock",
      providers = {
        bedrock = {
          model = "anthropic.claude-sonnet-4-20250514-v1:0",
          aws_region = "us-west-2",
          aws_profile = "claude-profile",
        },
      },
    },
  },

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
