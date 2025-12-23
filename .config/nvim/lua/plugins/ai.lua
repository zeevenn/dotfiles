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
}
