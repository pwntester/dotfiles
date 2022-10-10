local ll = require("lualine")

local cache = {}

-- local function relpath(P, start)
--   local split, min, append = vim.split, math.min, table.insert
--   local compare = function(v)
--     return v
--   end
--   local startl, Pl = split(start, "/"), split(P, "/")
--   local n = min(#startl, #Pl)
--   local k = n + 1 -- default value if this loop doesn't bail out!
--   for i = 1, n do
--     if compare(startl[i]) ~= compare(Pl[i]) then
--       k = i
--       break
--     end
--   end
--   local rell = {}
--   for i = 1, #startl - k + 1 do
--     rell[i] = ".."
--   end
--   if k <= #Pl then
--     for i = k, #Pl do
--       append(rell, Pl[i])
--     end
--   end
--   return table.concat(rell, "/")
-- end

-- local function file()
--   local bufname = vim.fn.bufname()
--   if vim.startswith(bufname, "octo:") or vim.startswith(bufname, "codeql:") or vim.startswith(bufname, "docker:") then
--     return bufname
--   elseif vim.bo.filetype == "toggleterm" then
--     return "terminal (" .. vim.api.nvim_buf_get_var(0, "toggle_number") .. ")"
--   else
--     return relpath(vim.fn.fnamemodify(bufname, ":p"), vim.fn.getcwd())
--   end
-- end


local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local icons = require "pwntester.icons"

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local github = {
  function()
    local cwd = vim.fn.getcwd()

    if cache[cwd] then
      return cache[cwd]
    end

    local ok, outils = pcall(require, "octo.utils")
    if not ok then
      cache[cwd] = ""
      return ""
    end

    local name = outils.get_remote_name()

    if type(name) == "string" and name ~= "" then
      cache[cwd] = " " .. name
      return cache[cwd]
    else
      cache[cwd] = ""
      return ""
    end
  end,
  padding = { left = 0, right = 1 },
  --color = 'MoreMsg',
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" }, --{ 'nvim_lsp' },
  sections = { "error", "warn" },
  symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
  --padding = { left = 0, right = 1 },
  -- diagnostics_color = {
  --   error = 'DiagnosticError',
  --   warn  = 'DiagnosticWarn',
  -- },
}

local cwd = {
  function()
    return vim.fn.getcwd()
  end,
  padding = { left = 0, right = 1 },
  --color = 'CursorLineNr',
}

local location = {
  function()
    return vim.fn.col "." .. ":" .. vim.fn.line "." .. " " .. tostring(math.floor(vim.fn.line "." / vim.fn.line "$" * 100)) .. "%%"
  end,
  padding = { left = 0, right = 1 },
  --color = 'Normal',
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  padding = { left = 0, right = 1 },
  icons_enabled = true,
  icon = { color = 'CursorLineNr' },
  --color = 'CursorLineNr',
}

local spaces = {
  function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end
}

local lsp = {
  function()
    local lsp_servers = require('lsp_spinner').status()
    if lsp_servers then
      return lsp_servers
    else
      return ""
    end
  end,
  padding = { left = 0, right = 1 },
  icons_enabled = true,
  icon = { "" },
  -- icon = { "", color = 'CursorLineNr' },
  -- color = function()
  --   local servers = require('lsp_spinner').status()
  --   if #servers > 0 then
  --     return 'MoreMsg'
  --   else
  --     return 'ErrorMsg'
  --   end
  -- end
}

local M = {}

function M.setup()
  ll.setup {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "nautilus_vscode",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = g.special_buffers,
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { branch, github },
      lualine_b = { diagnostics },
      lualine_x = { cwd, diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { lsp },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end

return M
