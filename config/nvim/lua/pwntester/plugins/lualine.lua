local ll = require("lualine")

local cache = {}

local function relpath(P, start)
  local split, min, append = vim.split, math.min, table.insert
  local compare = function(v)
    return v
  end
  local startl, Pl = split(start, "/"), split(P, "/")
  local n = min(#startl, #Pl)
  local k = n + 1 -- default value if this loop doesn't bail out!
  for i = 1, n do
    if compare(startl[i]) ~= compare(Pl[i]) then
      k = i
      break
    end
  end
  local rell = {}
  for i = 1, #startl - k + 1 do
    rell[i] = ".."
  end
  if k <= #Pl then
    for i = k, #Pl do
      append(rell, Pl[i])
    end
  end
  return table.concat(rell, "/")
end

local function github()
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
end

local function cwd()
  return vim.fn.getcwd()
end

local function file()
  local bufname = vim.fn.bufname()
  if vim.startswith(bufname, "octo:") or vim.startswith(bufname, "codeql:") or vim.startswith(bufname, "docker:") then
    return bufname
  elseif vim.bo.filetype == "toggleterm" then
    return "terminal (" .. vim.api.nvim_buf_get_var(0, "toggle_number") .. ")"
  else
    return relpath(vim.fn.fnamemodify(bufname, ":p"), vim.fn.getcwd())
  end
end

local function position()
  return vim.fn.col "." .. ":" .. vim.fn.line "." .. " " .. tostring(math.floor(vim.fn.line "." / vim.fn.line "$" * 100)) .. "%%"
end

local function lsp()
  local lsp_servers = require('lsp_spinner').status()
  if lsp_servers then
    return lsp_servers
  else
    return ""
  end
end

local M = {}


local custom_onenord = require 'lualine.themes.onenord'
local onenord_colors = require("onenord.colors.onenord")
custom_onenord.normal.c.bg = onenord_colors.bg

function M.setup()
  ll.setup {
    options = {
      icons_enabled = true,
      --theme = "auto",
      theme = custom_onenord,
      section_separators = '',
      component_separators = '',
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          function() return " " end,
          padding = { left = 0, right = 0 },
          color = 'Comment',
        },
        {
          github,
          padding = { left = 0, right = 1 },
          color = 'MoreMsg',
        }
      },
      lualine_b = {
        {
          require('github-notifications').statusline_notification_count,
          padding = { left = 0, right = 1 },
          color = 'Statement',
        },
        {
          "branch",
          padding = { left = 0, right = 1 },
          color = 'Normal',
          icon = ""
        }
      },
      lualine_c = {
        {
          cwd,
          padding = { left = 0, right = 1 },
          color = 'WildMenu',
        }
      },
      lualine_x = {
        {
          file,
          padding = { left = 0, right = 1 },
          color = 'WildMenu',
        },
        {
          position,
          padding = { left = 0, right = 1 },
          color = 'Normal',
        }
      },
      lualine_y = {
        {
          "filetype",
          padding = { left = 0, right = 1 },
          icons_enabled = true,
          icon = { color = 'WildMenu' },
          color = 'WildMenu',
        },
      },
      lualine_z = {
        {
          lsp,
          padding = { left = 0, right = 1 },
          icons_enabled = true,
          icon = { "", color = 'WildMenu' },
          color = function()
            local servers = require('lsp_spinner').status()
            if #servers > 0 then
              return 'MoreMsg'
            else
              return 'ErrorMsg'
            end
          end
        },
        {
          "diagnostics",
          padding = { left = 0, right = 1 },
          sources = { 'nvim_lsp' },
          sections = { 'error', 'warn' },
          symbols = { error = ' ', warn = ' ' },
          colored = true,
          diagnostics_color = {
            error = 'DiagnosticError',
            warn  = 'DiagnosticWarn',
          },
        }
      }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end

return M
