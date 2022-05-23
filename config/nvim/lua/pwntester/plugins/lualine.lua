local function setup()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    return
  end

  local status_gps_ok, gps = pcall(require, "nvim-gps")
  if not status_gps_ok then
    return
  end

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local icons = require "pwntester.icons"

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
    cond = hide_in_width,
  }

  local mode = {
    "mode",
    fmt = function(str)
      return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  local nvim_gps = function()
    local gps_location = gps.get_location()
    if gps_location == "error" then
      return ""
    else
      return gps.get_location()
    end
  end

  lualine.setup {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "nautilus_blue",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      -- disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
      disabled_filetypes = { "alpha", "dashboard", "toggleterm" },
      always_divide_middle = true,
    },
    sections = {
      -- lualine_a = { branch, diagnostics },
      lualine_a = { branch },
      lualine_b = { diagnostics },
      lualine_c = {
        {
          function()
            local fg = "#228b22" -- not modified
            if vim.bo.modified then
              fg = "#c70039" -- unsaved
            elseif not vim.bo.modifiable then
              fg = "#a70089"
            end -- readonly
            vim.cmd("hi! lualine_filename_status guifg=" .. fg)
            -- return "%t %m"
            return "%m"
          end,
          -- color = "lualine_filename_status",
        },
      },
      -- lualine_c = {},
      -- lualine_c = {
      --   { nvim_gps, cond = hide_in_width },
      -- },
      -- lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { progress },
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
end

return { setup = setup }
