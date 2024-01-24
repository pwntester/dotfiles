local entry_display = require "telescope.pickers.entry_display"

local M = {}

local displayer = entry_display.create {
  separator = " ",
  items = {
    { width = 8 },        -- commit
    { width = 8 },        -- lang
    { remaining = true }, -- nwo
  },
}

local make_display = function(e)
  local parts = vim.split(e.value, "/")
  local db = parts[#parts]
  local nwo = parts[#parts - 2] .. "/" .. parts[#parts - 1]
  local langAndCommit = vim.split(db:gsub("%.zip", ""), "-")
  local lang = langAndCommit[1]
  local commit = langAndCommit[2]
  return displayer {
    { commit, "TelescopeResultsComment" },
    { lang,   "TelescopeResultsNumber" },
    { nwo,    "TelescopeResultsString" },
  }
end

local entry_maker = function(entry)
  return {
    valid = entry,
    value = entry,
    ordinal = entry,
    display = make_display,
  }
end

function M.setup()
  require("codeql").setup {
    find_databases_cmd = { "gh", "qldb", "list" },
    database_list_entry_maker = entry_maker,
    results = {
      max_paths = 15,
      max_path_depth = nil,
    },
    panel = {
      width = 80,
      group_by = "sink",
      show_filename = true,
      long_filename = false,
      context_lines = 3,
    },
    max_ram = 64000,
  }
end

return M
