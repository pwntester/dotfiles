
local function setup()
  require "bufferline".setup {
    options = {
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 18,
      enforce_regular_tabs = true,
      view = "multiwindow",
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "thin",
      show_tab_indicators = true,
      diagnostics = "nvim_lsp"
    },
    highlights = {
      buffer_selected = {
        guifg = "#0b1f41",
        guibg = "#ffcc66"
      },
      separator_selected = {
        guifg = "#ffcc66",
        guibg = "#ffcc66"
      },
    }
  }
end

return {
  setup = setup;
}
