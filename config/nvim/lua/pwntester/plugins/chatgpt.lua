return {
  "jackMort/ChatGPT.nvim",
  cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTRun", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
  config = function()
    require("chatgpt").setup {
      api_key_cmd = "op read op://Personal/OpenAI/text --no-newline",
      actions_paths = { "~/.config/nvim/lua/pwntester/plugins/chatgpt.json" },
    }
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  -- stylua: ignore
  keys = {
  }
}
