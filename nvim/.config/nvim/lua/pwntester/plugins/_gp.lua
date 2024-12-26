return {
  "robitx/gp.nvim",
  enabled = false,
  keys = { "<Leader>g" },
  config = function()
    require("gp").setup {
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = { "op", "read", "op://Personal/OpenAI/text", "--no-newline" },
        },
      },
      agents = { { name = "ChatGPT3-5", disable = true } },
      hooks = {
        Translator = function(gp, params)
          local chat_system_prompt = "You are a Translator, please translate between Spanish and English."
          local agent = gp.get_chat_agent "ChatGPT4o"
          gp.cmd.ChatNew(params, chat_system_prompt, agent)
        end,
        BufferChatNew = function(gp, _)
          -- call GpChatNew command in range mode on whole buffer
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
        end,
      },
      keys = {
        { "<leader>gr", "<Cmd>GpRewrite<CR>", desc = "Rewrite" },
        { "<leader>ga", "<Cmd>GpAppend<CR>", desc = "Rewrite" },
      },
    }
  end,
}
