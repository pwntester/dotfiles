local M = {}

local colors = {
  fg = "#C8D0E0",
  fg_light = "#E5E9F0",
  bg = "#2E3440",
  gray = "#646A76",
  light_gray = "#6C7A96",
  cyan = "#88C0D0",
  blue = "#81A1C1",
  dark_blue = "#5E81AC",
  green = "#A3BE8C",
  light_green = "#8FBCBB",
  dark_red = "#BF616A",
  red = "#D57780",
  light_red = "#DE878F",
  pink = "#E85B7A",
  dark_pink = "#E44675",
  orange = "#D08F70",
  yellow = "#EBCB8B",
  purple = "#B988B0",
  light_purple = "#B48EAD",
  none = "NONE",
}

-- more semantically meaningful colors

colors.error = colors.dark_red
colors.warn = colors.orange
colors.info = colors.green
colors.hint = colors.purple

colors.diff_add = colors.green
colors.diff_add_bg = "#394E3D"
colors.diff_change = colors.dark_blue
colors.diff_change_bg = "#39495D"
colors.diff_remove = colors.red
colors.diff_remove_bg = "#4D2B2E"
colors.diff_text_bg = "#405D7E"

colors.float = "#3B4252"
colors.highlight = "#3F4758"
colors.highlight_dark = "#434C5E"
colors.selection = "#4C566A"

--local colors = require("onenord.colors.onenord")
colors.active_light = "#353B49"
colors.active_dark = "#242932"
colors.active = colors.active_dark
colors.alt_dark = colors.active_dark -- "#1e222a"
colors.alt_light = colors.active_dark -- "#1c1f26"

M.colors = {
  bg = "#2e3440",
  fg = "#ECEFF4",
  red = "#bf616a",
  orange = "#d08770",
  yellow = "#ebcb8b",
  blue = "#5e81ac",
  green = "#a3be8c",
  cyan = "#88c0d0",
  magenta = "#b48ead",
  pink = "#FFA19F",
  grey1 = "#f8fafc",
  grey2 = "#f0f1f4",
  grey3 = "#eaecf0",
  grey4 = "#d9dce3",
  grey5 = "#c4c9d4",
  grey6 = "#b5bcc9",
  grey7 = "#929cb0",
  grey8 = "#8e99ae",
  grey9 = "#74819a",
  grey10 = "#616d85",
  grey11 = "#464f62",
  grey12 = "#3a4150",
  grey13 = "#333a47",
  grey14 = "#242932",
  grey15 = "#1e222a",
  grey16 = "#1c1f26",
  grey17 = "#0f1115",
  grey18 = "#0d0e11",
  grey19 = "#020203",
}

M.setup = function()
  onenord = require "onenord"
  onenord.setup {
    borders = true,
    fade_nc = false,
    styles = {
      comments = "italic",
      strings = "NONE",
      keywords = "NONE",
      functions = "italic",
      --variables = "bold",
      variables = "NONE",
      diagnostics = "underline",
    },
    disable = {
      background = false,
      cursorline = false,
      eob_lines = true,
    },
    custom_highlights = {

      NormalActive = { fg = colors.fg, bg = colors.active },
      -- Mini
      MiniIndentscopeSymbol = { fg = colors.selection, style = "nocombine" },
      MiniCursorword = { fg = colors.blue, style = "nocombine" },
      --MiniCursorCurrent = { fg = colors.grey, bg = config.transparent and colors.none or colors.bg },

      -- NeoTree
      NeoTreeNormal = { fg = colors.fg, bg = colors.active },
      NeoTreeNormalNC = { fg = colors.fg, bg = colors.active },
      NeoTreeDirectoryName = { fg = colors.blue },
      NeoTreeDirectoryIcon = { fg = colors.blue },
      NeoTreeFileIcon = { fg = colors.blue },
      --NeoTreeFileName = { fg = colors.grey, bg = config.transparent and colors.none or colors.bg_alt },
      NeoTreeRootName = { fg = colors.yellow },
      NeoTreeCursorLine = { fg = colors.yellow },

      --VertSplit = { fg = colors.active },
      VertSplit = { fg = colors.bg },
      WinSeparator = { fg = colors.blue },

      GitSignsAdd = { fg = colors.green },
      GitSignsChange = { fg = colors.orange },
      GitSignsDelete = { fg = colors.red },

      NormalFloat = { bg = colors.active },
      FloatBorder = { bg = colors.active, fg = colors.active },

      TelescopePromptPrefix = { bg = colors.active },
      TelescopePromptNormal = { bg = colors.active },
      TelescopePromptBorder = { bg = colors.active, fg = colors.active },
      TelescopePromptTitle = { fg = colors.active },

      TelescopeResultsNormal = { bg = colors.alt_dark },
      TelescopeResultsBorder = { bg = colors.alt_dark, fg = colors.alt_dark },
      TelescopeResultsTitle = { fg = colors.alt_dark },

      TelescopePreviewNormal = { bg = colors.alt_light },
      TelescopePreviewBorder = { bg = colors.alt_light, fg = colors.alt_light },
      TelescopePreviewTitle = { fg = colors.alt_light },

      PmenuSel = { bg = "#3a4150" },
      Pmenu = { bg = colors.active },
      --CmpGhostText = { fg = utils.darken(c.grey, 0.8), bg = c.base00 },
      CmpFloat = { bg = colors.active },
      CmpBorder = { fg = colors.bg, bg = colors.active },
      PmenuThumb = { bg = colors.blue },

      LspFloatWinNormal = { fg = colors.fg, bg = colors.active },
      LspFloatWinBorder = { fg = colors.active },

    },
  }
end

return M
