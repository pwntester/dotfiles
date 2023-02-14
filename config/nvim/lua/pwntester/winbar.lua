local icons = require("pwntester.icons")

local M = {}

local status_ok, locator = pcall(require, "nvim-navic")
--local status_ok, locator = pcall(require, "nvim-gps")
if not status_ok then
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
  local errHl, warnHl = "LineNr", "LineNr"
  local bufnr = vim.api.nvim_get_current_buf()
  local lsp_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if #lsp_clients > 0 then
    for _, lsp_client in ipairs(lsp_clients) do
      if lsp_client.name ~= "null-ls" then
        errHl, warnHl = "DiagnosticError", "DiagnosticWarn"
        break
      end
    end
  end

  return string.format(
    "%%#%s#%s %%*%s %%#%s#%s %%*%s ",
    errHl,
    icons.diagnostics.Error,
    count[vim.diagnostic.severity.ERROR],
    warnHl,
    icons.diagnostics.Warning,
    count[vim.diagnostic.severity.WARN]
  )
end

M.filename = function()
  local bufname = vim.fn.bufname()
  local codeql_archive = false
  if string.sub(bufname, 1, 8) == "codeql:/" then
    codeql_archive = true
  end
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
    if codeql_archive then
      filename = "[CODEQL] " .. filename
    end
    return " " .. "%#" .. icon_hl .. "#" .. file_icon .. "%*" .. " " .. "%#WinbarFilename#" .. filename .. "%*"
  end
end

M.winbar = function()
  local filename = M.filename()
  local ok, location = pcall(locator.get_location, {})
  local left = ""
  if ok and locator.is_available() and location ~= "error" and not isempty(location) then
    left = filename .. " " .. "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%* " .. location
  elseif filename then
    left = filename
  end
  local right = M.diagnostics()

  return left .. "%=" .. right
end

return M
