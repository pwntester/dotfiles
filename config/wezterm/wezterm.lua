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
-- local a = wezterm.action
local k = require "keys"
-- local c = require "colors"

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
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

config.term = "xterm-kitty"

config.set_environment_variables = {
  -- Works better with images and cursors
  TERM = "xterm-kitty",
  --TERM = "xterm-256color",
  LC_ALL = "en_US.UTF-8",
}

config.color_scheme = "Catppuccin Macchiato"

-- general options
config.adjust_window_size_when_changing_font_size = false
config.debug_key_events = false
config.native_macos_fullscreen_mode = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"

-- keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
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
  k.cmd_to_tmux_prefix("K", "T"), -- sesh
  k.cmd_to_tmux_prefix("g", "g"), -- lazygit/gitui
  k.cmd_to_tmux_prefix("f", "p"), -- floax
  k.cmd_to_tmux_prefix("t", "c"), -- floax
  k.cmd_to_nvim_command("p", ":CommandPalette"),
  -- k.cmd("t", {
  --   nvim = ":ObsidianToday",
  --   tmux = "c", -- new window
  -- }),
  { mods = "CMD", key = "F", action = wezterm.action.ToggleFullScreen },
}

-- tab bar
config.enable_tab_bar = false

-- image protocol
config.enable_kitty_graphics = true

return config
