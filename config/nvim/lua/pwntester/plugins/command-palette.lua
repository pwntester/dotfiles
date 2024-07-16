return {
  "AtleSkaanes/command-palette.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  version = "*",
  config = function()
    local cmd_palette = require "command-palette"
    local vim = vim
    cmd_palette.setup {
      commands = {
        {
          name = "test",
          -- category = "obsidian",
          cmd = function()
            local bufnr = vim.api.nvim_get_current_buf()
            print("TEST CALLED from ", bufnr)
          end,
        },
      },
      icons = {
        category = "F",
        cmd = "C",
        back = "..",
      },
    }
    vim.cmd [[command! CommandPalette :call v:lua.require'command-palette'.run_cmd.ui()]]
  end,
}
