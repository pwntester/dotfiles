return {
  "magicalne/nvim.ai",
  enabled = false,
  depennedencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
  },
  opts = {
    provider = "anthropic",
    ui = {
      prompt_prefix = "❯ ",
    },
    anthropic = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20240620",
      temperature = 0,
      max_tokens = 4096,
      ["local"] = false,
    },
    openai = {
      endpoint = "https://api.openai.com",
      model = "gpt-4o",
      temperature = 0,
      max_tokens = 4096,
      ["local"] = false,
    },
    keymaps = {
      toggle = "<leader>c", -- Toggle chat dialog
      send = "<CR>", -- Send message in normal mode
      close = "q", -- Close chat dialog
      clear = "<C-l>", -- Clear chat history
      inline_assist = "<leader>i", -- Run InlineAssist command with prompt
      accept_code = "<leader>ia",
      reject_code = "<leader>ij",
    },
  },
}
