return {
  "echasnovski/mini.nvim",
  name = "mini",
  version = false,
  keys = {
    { "<leader>e", mode = "n" },
    { "<leader>ff", mode = "n" },
    { "<leader>b", mode = "n" },
    { "<leader>fr", mode = "n" },
    { "<leader>fw", mode = "n" },
    { "<leader>q", mode = "n" },
    { "<leader>ti", mode = "n" },
    { "<C-q>", mode = "n" },
    { "gcc", mode = "n" },
    { "<leader>", mode = "n" },
    { "gc", mode = "n" },
    { "gc", mode = "x" },
    { "H", mode = "x" },
    { "J", mode = "x" },
    { "K", mode = "x" },
    { "L", mode = "x" },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      package.loaded["nvim-web-devicons"] = {}
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  event = function()
    if vim.fn.argc() == 0 then
      return "VimEnter"
    else
      return { "InsertEnter", "LspAttach" }
    end
  end,

  config = function()
    local mini_modules = {
      "ai",
      "bufremove",
      "comment",
      "icons",
      "pairs",
      "surround",
      -- "starter",
      -- "files",
      -- "hipatterns",
      -- "pick",
      -- "move",
      -- "indentscope",
      -- "extra",
      -- "visits",
      -- "clue",
      -- "notify",
      -- "git",
      -- "diff",
    }
    --require("core.mappings").mini()
    local mini_config = require "pwntester.mini-config"
    for _, module in ipairs(mini_modules) do
      require("mini." .. module).setup(mini_config[module])
    end
  end,
}
