return {
  "ahkohd/context.nvim",
  config = function()
    local context = require("context")
    context.setup({
      picker = context.pickers.snacks,
      prompts = {
        explain = "Explain {this}",
        fix = "Fix the issue at {position}",
        review = "Review {file} for issues",
      },
    })
  end,
  keys = {
    {
      "<leader>a",
      function()
        require("context").pick()
      end,
      desc = "Context",
      mode = { "n", "v" },
    },
  },
}
