-- LLM-based assistant
return {
  {
    -- https://github.com/gsuuon/model.nvim
    "gsuuon/model.nvim",
    enabled = false,
    init = function()
      vim.filetype.add {
        extension = {
          mchat = "mchat",
        },
      }
    end,
    ft = "mchat",
    lazy = true,
    cmd = {
      "M",
      "Model",
      "Mchat",
    },
    keys = {
      --{ "<leader>aa", "<cmd>M<cr>", desc = "Run a completion prompt" },
      { "<C-s>", "<cmd>Mchat<cr>", desc = "Run a chat buffer", ft = "mchat", mode = { "i", "n", "v" } },
      { "<leader>as", "<cmd>Mselect<cr>", desc = "Select the response under the cursor" },
      { "<leader>ac", "<cmd>Mchat claude<cr>", desc = "Select the response under the cursor" },
      { "<leader>aA", "<cmd>MCadd<cr>", desc = "Add the current file into context" },
      { "<leader>aR", "<cmd>MCremove<cr>", desc = "Remove the current file from context" },
      { "<leader>aC", "<cmd>MCclear<cr>", desc = "Clear context" },
    },
    config = function()
      local anthropic = require "model.providers.anthropic"
      local starter_prompts = require "model.prompts.starters"
      local mode = require("model").mode
      -- local prompts = require "model.util.prompts"

      -- langchain use: https://wesl.ee/Enhancing_Neovim_Workflows_With_LLMs_Model.nvim/
      --
      local proofread = {
        provider = anthropic,
        mode = mode.APPEND,
        hl_group = "RenderMarkdownDash",
        builder = function(input, context)
          -- context.selection: holds if the user has selected a text
          -- context.filename: filenames added to the context?
          -- local surrounding_text = prompts.limit_before_after(context, 30)
          return {
            model = "claude-3-5-sonnet-20240620",
            messages = {
              {
                role = "user",
                content = "Your task is to proofread and revise English text written by a non-native English speaker to ensure it adheres to correct grammatical rules and sounds idiomatic. This includes checking for proper punctuation, sentence structure, word choice, and phrasing. Here is the text to proofread: "
                  .. input,
              },
            },
          }
        end,
      }
      require("model").setup {
        default_prompt = proofread,
        prompts = vim.tbl_extend("force", starter_prompts, {
          proofread = proofread,
        }),
      }
    end,
  },
}
