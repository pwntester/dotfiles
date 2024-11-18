local wezterm = require "wezterm"
local a = wezterm.action
local M = {}

M.multiple_actions = function(keys)
  local actions = {}
  for key in keys:gmatch "." do
    table.insert(actions, a.SendKey { key = key })
  end
  table.insert(actions, a.SendKey { key = "\n" })
  return a.Multiple(actions)
end

M.nvim_normal_cmd = function(command)
  return wezterm.action_callback(function(win, pane)
    local procName = pane:get_user_vars().WEZTERM_PROG
    -- pane:get_foreground_process_name():gsub("(.*/)(.*)", "%2")
    if procName == "nvim" or procName == "vi" or procName == "vim" then
      win:perform_action(
        a.Multiple {
          a.SendKey { key = "\x1b" }, -- escape
          M.multiple_actions(command),
        },
        pane
      )
    end
  end)
end

M.key_table = function(mods, key, action)
  return {
    mods = mods,
    key = key,
    action = action,
  }
end

M.cmd_key = function(key, action)
  return M.key_table("CMD", key, action)
end

M.cmd_to_tmux_prefix = function(key, tmux_key)
  return M.cmd_key(
    key,
    a.Multiple {
      a.SendKey { mods = "CTRL", key = "b" },
      a.SendKey { key = tmux_key },
    }
  )
end

M.cmd_to_nvim_command = function(key, nvim_cmd)
  return M.cmd_key(key, M.nvim_normal_cmd(nvim_cmd))
end

M.cmd = function(key, actions)
  local action = wezterm.action_callback(function(win, pane)
    local procName = pane:get_user_vars().WEZTERM_PROG
    print("PROC: " .. procName)
    if procName == "nvim" or procName == "vi" or procName == "vim" then
      win:perform_action(
        a.Multiple {
          a.SendKey { key = "\x1b" }, -- escape
          M.multiple_actions(actions["nvim"]),
        },
        pane
      )
    elseif procName == "" then
      print "TMUX"
      win:perform_action(
        a.Multiple {
          a.SendKey { mods = "CTRL", key = "b" },
          a.SendKey { key = actions["tmux"] },
        },
        pane
      )
    end
  end)
  return M.cmd_key(key, action)
end

return M
