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
          name = "New Meeting Note",
          cmd = function()
            vim.cmd [[ObsidianNewMeetingNote]]
          end,
        },
        {
          name = "New 1:1 Note",
          cmd = function()
            vim.cmd [[ObsidianNewOneOnOneNote]]
          end,
        },
        {
          name = "New Note",
          cmd = function()
            vim.cmd [[ObsidianNew]]
          end,
        },
      },
      icons = {
        category = "",
        cmd = "",
        back = "..",
      },
    }
    vim.cmd [[command! CommandPalette :call v:lua.require'command-palette'.run_cmd.ui()]]
  end,
}
