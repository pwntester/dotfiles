--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

-- check logs with CTRL-SHIFT-L or in $HOME/.local/share/wezterm
-- wezterm.log_info("@isEditor,name=" .. procName)

local wezterm = require "wezterm"
local a = wezterm.action
local k = require "keys"
local c = require "colors"

local config = wezterm.config_builder()

-- fonts
-- config.font = wezterm.font("MonispaceNe NF", { weight = "Bold", italic = true })
config.font = wezterm.font_with_fallback {
  -- { family = "MonaspiceNe Nerd Font", scale = 1.1, weight = "Light" },
  { family = "MonaspiceNe Nerd Font", scale = 1.0, weight = "Medium" },
  { family = "MonaspiceRn Nerd Font", scale = 1.0, weight = "Medium" },
  { family = "MonaspiceKr Nerd Font", scale = 1.0, weight = "Medium" },
  { family = "MonaspiceAr Nerd Font", scale = 1.0, weight = "Medium" },
  { family = "CommitMono Nerd Font", scale = 1.0 },
}
config.font_size = 15.0
config.line_height = 1.0

config.window_padding = {
  left = "20",
  right = "10",
  top = "20",
  bottom = "0.5cell",
}

-- environment variables
config.set_environment_variables = {
  TERM = "xterm-256color",
  LC_ALL = "en_US.UTF-8",
}

-- colors
-- config.colors = c.colors
-- local custom = wezterm.color.get_builtin_schemes()["Catppuccin Cobalt"]
-- custom.background = "#1d2433"
-- custom.tab_bar.background = "#1d2433"
--custom.tab_bar.inactive_tab.bg_color = "#0f0f0f"
--custom.tab_bar.new_tab.bg_color = "#080808"
-- config.color_schemes = {
--   ["Catppuccin Cobalt"] = custom,
-- }
config.color_scheme = "Catppuccin Macchiato" -- or Mocha,  Macchiato, Frappe, Latte

-- general options
config.adjust_window_size_when_changing_font_size = false
config.debug_key_events = false
config.native_macos_fullscreen_mode = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"

-- window background
-- config.text_background_opacity = 0.3
-- config.window_background_image = '/path/to/wallpaper.jpg'
-- config.window_background_opacity = 0.9
-- config.window_background_image_hsb = {
--   -- Darken the background image by reducing it to 1/3rd
--   brightness = 0.3,
--
--   -- You can adjust the hue by scaling its value.
--   -- a multiplier of 1.0 leaves the value unchanged.
--   hue = 1.0,
--
--   -- You can adjust the saturation also.
--   saturation = 1.0,
-- }

-- keys
-- config.enable_csi_u_key_encoding = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
-- stylua: ignore
config.keys = {
  k.cmd_to_tmux_prefix("t", "c"), -- new window
  k.cmd_to_tmux_prefix("1", "1"), -- change to window 1
  k.cmd_to_tmux_prefix("2", "2"), -- change to window 2
  k.cmd_to_tmux_prefix("3", "3"), -- change to window 3
  k.cmd_to_tmux_prefix("4", "4"), -- change to window 4
  k.cmd_to_tmux_prefix("5", "5"), -- change to window 5
  k.cmd_to_tmux_prefix("6", "6"), -- change to window 6
  k.cmd_to_tmux_prefix("7", "7"), -- change to window 7
  k.cmd_to_tmux_prefix("8", "8"), -- change to window 8
  k.cmd_to_tmux_prefix("9", "9"), -- change to window 9
  k.cmd_to_tmux_prefix("0", "0"), -- change to window 0
  k.cmd_to_tmux_prefix("k", "T"), -- sesh
  k.cmd_to_tmux_prefix("g", "g"), -- lazygit
  k.cmd_to_tmux_prefix("p", "p"), -- floax
  k.cmd_to_tmux_prefix("G", "P"), -- floax
  { mods = "SHIFT|CTRL", key = "n", action = wezterm.action.ToggleFullScreen },
  --k.cmd_to_nvim_command("p", ":CommandPalette")
}

-- inactive pane colors
-- config.inactive_pane_hsb = {
--   saturation = 0.94,
--   brightness = 0.5,
-- }

-- tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true
wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f7768e"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#bb9af7"
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == "userdata" then
      -- Wezterm introduced the URL object in 20240127-113634-bbcac864
      cwd = basename(cwd.file_path)
    else
      -- 20230712-072601-f4abf8fd or earlier version
      cwd = basename(cwd)
    end
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Time
  local time = wezterm.strftime "%H:%M"

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format {
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " |" },
  })

  -- Right status
  window:set_right_status(wezterm.format {
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "#e0af68" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  })
end)

-- smart splits plugin
-- local smart_splits = wezterm.plugin.require "https://github.com/mrjones2014/smart-splits.nvim"
-- smart_splits.apply_to_config(config, {
--   direction_keys = { "h", "j", "k", "l" },
--   modifiers = {
--     move = "CTRL",
--     resize = "META",
--   },
-- })

-- Setting the Image Protocol
config.enable_kitty_graphics = true

return config
