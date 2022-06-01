local icons = require("pwntester.icons")

local M = {}

local status_gps_ok, gps = pcall(require, "nvim-gps")
if not status_gps_ok then
  return
end

local function isempty(s)
  return s == nil or s == ""
end

M.diagnostics = function()
  local diagnostics = vim.diagnostic.get(0)
  local count = {}
  count[vim.diagnostic.severity.ERROR] = 0
  count[vim.diagnostic.severity.WARN] = 0
  count[vim.diagnostic.severity.HINT] = 0
  count[vim.diagnostic.severity.INFO] = 0
  for _, diagnostic in ipairs(diagnostics) do
    count[diagnostic.severity] = count[diagnostic.severity] + 1
  end
  return string.format(
    "%%#DiagnosticError#%s %%*%s %%#DiagnosticWarn#%s %%*%s",
    icons.diagnostics.Error,
    count[vim.diagnostic.severity.ERROR],
    icons.diagnostics.Warning,
    count[vim.diagnostic.severity.WARN]
  )
end

M.filename = function()
  local filename = vim.fn.expand "%:t"
  local extension = ""
  local file_icon = ""
  local file_icon_color = ""
  local default_file_icon = ""
  local default_file_icon_color = ""

  if not isempty(filename) then
    extension = vim.fn.expand "%:e"

    local default = false

    if isempty(extension) then
      extension = ""
      default = true
    end

    file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

    local icon_hl = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, icon_hl, { fg = file_icon_color })
    if file_icon == nil then
      file_icon = default_file_icon
      file_icon_color = default_file_icon_color
    end

    return " " .. "%#" .. icon_hl .. "#" .. file_icon .. "%*" .. " " .. "%#WinbarFilename#" .. filename .. "%*"
  end
end

M.winbar = function()
  local filename = M.filename()
  local status_ok, gps_location = pcall(gps.get_location, {})

  local left = ""
  if status_ok and gps.is_available() and gps_location ~= "error" and not isempty(gps_location) then
    left = filename .. " " .. icons.ui.ChevronRight .. " " .. gps_location
  elseif filename then
    left = filename
  end
  local right = M.diagnostics()

  return left .. "%=" .. right
end

return M
