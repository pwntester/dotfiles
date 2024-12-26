local M = {}

M.palette = {
  cobalt = "#1d2433",
  black = "#272b30",
  red = "#cc6666",
  green = "#bdb968",
  yellow = "#f8d78c",
  blue = "#81a2be",
  magenta = "#b08cba",
  cyan = "#7fb2c8",
  white = "#afb4c3",
}

M.colors = {
  -- The default text color
  foreground = M.palette.white,
  -- The default background color
  background = M.palette.cobalt,

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = "#52ad70",
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = M.palette.black,
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = "#52ad70",

  -- the foreground color of selected text
  selection_fg = M.palette.black,
  -- the background color of selected text
  selection_bg = M.palette.yellow,

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = "#222222",

  -- The color of the split lines between panes
  split = M.palette.cyan,

  ansi = {
    M.palette.black,
    M.palette.red,
    M.palette.green,
    M.palette.yellow,
    M.palette.blue,
    M.palette.magenta,
    M.palette.cyan,
    M.palette.white,
  },
  brights = {
    M.palette.black,
    M.palette.red,
    M.palette.green,
    M.palette.yellow,
    M.palette.blue,
    M.palette.magenta,
    M.palette.cyan,
    M.palette.white,
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = "#af8700" },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = "orange",

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = "#000000" },
  copy_mode_active_highlight_fg = { AnsiColor = "Black" },
  copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
  copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

  quick_select_label_bg = { Color = "peru" },
  quick_select_label_fg = { Color = "#ffffff" },
  quick_select_match_bg = { AnsiColor = "Navy" },
  quick_select_match_fg = { Color = "#ffffff" },

  tab_bar = {
    background = M.palette.cobalt,
    active_tab = {
      fg_color = M.palette.cobalt,
      bg_color = M.palette.cyan,
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = M.palette.cobalt,
      fg_color = M.palette.white,
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    new_tab = {
      bg_color = M.palette.cobalt,
      fg_color = M.palette.green,
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
  },
}

return M
