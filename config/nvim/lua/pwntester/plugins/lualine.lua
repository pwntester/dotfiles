vim.g.test_status = ""

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  config = function()
    local branch = {
      "branch",
      icons_enabled = true,
      icon = "",
      color = "CursorLineNr",
    }

    local cwd = {
      function()
        return vim.fn.getcwd()
      end,
      padding = { left = 0, right = 1 },
    }

    require("lualine").setup {
      options = {
        globalstatus = true,
        icons_enabled = true,
        theme = "catppuccin", -- "nautilus_halcyon",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" }, -- require("pwntester.globals").special_buffers, -- { "alpha", "dashboard", "toggleterm" },
        ignore_focus = require("pwntester.globals").special_buffers, -- { "alpha", "dashboard", "toggleterm" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { branch, "diagnostics" }, --, github },
        lualine_b = { cwd },
        lualine_c = {},
        lualine_x = { "filetype" },
        lualine_y = { "diff" },
        lualine_z = { "location" },
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
