local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require "CopilotChat.actions"
    local items = actions[kind .. "_actions"]()
    if not items then
      print("No " .. kind .. " found on the current line")
      return
    end
    local ok = pcall(require, "fzf-lua")
    require("CopilotChat.integrations." .. (ok and "fzflua" or "telescope")).pick(items)
  end
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require "CopilotChat.select"
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show help actions with telescope
      { "<leader>ad", M.pick "help", desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- Show prompts actions with telescope
      { "<leader>ap", M.pick "prompt", desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = false,
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false, -- disable built-in keymapping
          hide_during_completion = false,
          keymap = {
            accept = "<Right>",
            accept_word = "<A-l>",
            accept_line = false,
            next = "<A-k>",
            prev = "<A-j>",
            dismiss = "<esc>",
          },
        },
      }
    end,
  },
}
--
-- return {
--   "github/copilot.vim",
--   config = function()
--     vim.g.copilot_no_tab_map = true
--     vim.cmd [[imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")]]
--     vim.g.copilot_filetypes = {
--       ["*"] = false,
--       python = true,
--       sh = true,
--       lua = true,
--       go = true,
--       ql = true,
--       html = true,
--       javascript = true,
--       typescript = true,
--     }
--   end,
-- }

-- -- COPILOT
-- ["i<C-l>"] = { [[copilot#Accept("<CR>")]], script = true, expr = true, desc = "Accept Copilot suggestion" },
-- ["i<Right>"] = { [[copilot#Accept("<CR>")]], script = true, expr = true, desc = "Accept Copilot suggestion" },
-- ["i<A-s>"] = { [[<Plug>(copilot-suggest)]], noremap = false, desc = "Force Copilot suggestion" },
-- ["i<A-j>"] = { [[<Plug>(copilot-next)]], noremap = false, desc = "Show next Copilot suggestion" },
-- ["i<A-k>"] = { [[<Plug>(copilot-previous)]], noremap = false, desc = "Show previous Copilot suggestion" },
-- ["i<A-l>"] = {
--   function()
--     vim.fn["copilot#Accept"] ""
--     local bar = vim.fn["copilot#TextQueuedForInsertion"]()
--     return vim.fn.split(bar, [[[ .]\zs]])[1]
--   end,
--   silent = true,
--   script = true,
--   expr = true,
--   desc = "Accept next Copilot word suggestion",
-- },
-- ["i<A-m>"] = {
--   function()
--     vim.fn["copilot#Accept"] ""
--     local bar = vim.fn["copilot#TextQueuedForInsertion"]()
--     return vim.fn.split(bar, [[[\n]\zs]])[1]
--   end,
--   silent = true,
--   script = true,
--   expr = true,
--   desc = "Accept pre",
-- },
