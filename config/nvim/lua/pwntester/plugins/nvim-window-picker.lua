return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup {
      hint = "statusline-winbar",
      show_prompt = true,
      prompt_message = "Pick window: ",
      selection_chars = "FJDKSLA;CMRUEIWOQP",
      filter_rules = {
        autoselect_one = true,
        include_current = false,
        bo = {
          filetype = require("pwntester.globals").special_buffers,
          buftype = { "terminal", "quickfix" },
        },
        wo = {},
        file_path_contains = {},
        file_name_contains = {},
      },
      highlights = {
        statusline = {
          focused = {
            fg = "#ededed",
            bg = "#e35e4f",
            bold = true,
          },
          unfocused = {
            fg = "#ededed",
            bg = "#44ccFF",
            bold = true,
          },
        },
        winbar = {
          focused = {
            fg = "#ededed",
            bg = "#e35e4f",
            bold = true,
          },
          unfocused = {
            fg = "#ededed",
            bg = "#44ccFF",
            bold = true,
          },
        },
      },
    }
  end,
}
