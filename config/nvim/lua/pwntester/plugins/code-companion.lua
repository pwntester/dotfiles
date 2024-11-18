return {
  "olimorris/codecompanion.nvim",
  lazy = true,
  cmd = { "CodeCompanion", "CodeCompanionAdd", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionToggle" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    {
      "stevearc/dressing.nvim",
      opts = {},
    },
  },
  config = function()
    require("codecompanion").setup {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "ANTHROPIC_API_KEY",
            },
            schema = {
              model = {
                default = "claude-3-5-sonnet-20240620",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
      -- https://github.com/olimorris/codecompanion.nvim/blob/main/doc/RECIPES.md
      default_prompts = {
        ["My New Prompt"] = {
          strategy = "chat",
          description = "Some cool custom prompt you can do",
          prompts = {
            {
              role = "system",
              content = "You are an experienced developer with Lua and Neovim",
            },
            {
              role = "user",
              content = "Can you explain why ...",
            },
          },
        },
      },
    }
  end,
  keys = {
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Menu", mode = "v" },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Menu", mode = "n" },
    { "<leader>ac", "<cmd>CodeCompanionToogle<cr>", desc = "Code Companion Chat", mode = "n" },
    { "<leader>ac", "<cmd>CodeCompanionToogle<cr>", desc = "Code Companion Chat", mode = "v" },
    { "ga", "<cmd>CodeCompanionAdd<cr>", desc = "Code Companion Add", mode = "v" },
  },
}

-- Commands:
-- CodeCompanionActions - To open the Action Palette
-- CodeCompanion - Inline prompting of the plugin
-- CodeCompanion <slash_cmd> - Inline prompting of the plugin with a slash command e.g. /commit
-- CodeCompanionChat - To open up a new chat buffer
-- CodeCompanionChat <adapter> - To open up a new chat buffer with a specific adapter
-- CodeCompanionToggle - To toggle a chat buffer
-- CodeCompanionAdd - To add visually selected chat to the current chat buffer

-- Chat variables:
-- #buffer - Share the current buffer's content with the LLM. You can also specify line numbers with #buffer:8-20
-- #buffers - Share all current open buffers with the LLM
-- #editor - Share the buffers and lines that you see in the editor's viewport
-- #lsp - Share LSP information and code for the current buffer

-- Chat tools:
-- @code_runner - The LLM can trigger the running of any code from within a Docker container
-- @rag - The LLM can browse and search the internet for real-time information to supplement its response
-- @buffer_editor - The LLM can edit code in a Neovim buffer by searching and replacing blocks
