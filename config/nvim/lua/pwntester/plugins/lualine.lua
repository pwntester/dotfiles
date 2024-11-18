local custom_macchiato = require "lualine.themes.catppuccin-macchiato"
local base = "#24273a"
custom_macchiato.normal.c.bg = base
custom_macchiato.inactive.c.bg = base

return {
  "nvim-lualine/lualine.nvim",
  --event = "VeryLazy",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  config = function()
    require("lualine").setup {
      options = {
        globalstatus = true,
        icons_enabled = true,
        theme = custom_macchiato,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" },
        ignore_focus = require("pwntester.globals").special_buffers,
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "branch" },
        lualine_b = {
          {
            function()
              return vim.fn.getcwd()
            end,
            padding = { left = 0, right = 1 },
          },
        },
        lualine_c = {
          -- {
          --   -- "%#tmux_status_window_active#plugins   %#tmux_status_window_inactive_recent#plugins"
          --   require("tmux-status").tmux_windows,
          --   cond = require("tmux-status").show,
          --   padding = { left = 3 },
          -- },
        },
        lualine_x = {},
        lualine_y = { "filetype", "diagnostics" },
        lualine_z = {
          "location",
          -- {
          --   require("tmux-status").tmux_session,
          --   cond = require("tmux-status").show,
          --   padding = { left = 3 },
          -- },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end,
}
