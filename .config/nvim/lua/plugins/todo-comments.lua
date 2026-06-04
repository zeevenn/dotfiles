return {
  "folke/todo-comments.nvim",
  opts = {
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "hack" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
      error = { "#f38ba8" },
      warning = { "#fab387" },
      info = { "#89b4fa" },
      hint = { "#a6e3a1" },
      hack = { "#f9e2af" },
      perf = { "#cba6f7" },
      test = { "#74c7ec" },
    },
  },
}
