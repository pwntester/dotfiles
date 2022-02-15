local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local opts = require("telescope.themes").get_dropdown {}

vim.g.zk_notebook = "/Users/pwntester/bitacora"

local M = {}

local notes_templates = {
  {
    ordinal = 1,
    label = "SecLab team meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 2,
    label = "SecLab research targeting meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 3,
    label = "PSE sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 3,
    label = "Product sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 4,
    label = "CodeQL sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 5,
    label = "1-on-1 with Xavier",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 6,
    label = "Other meeting",
    directory = "resources/meeting notes",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 7,
    label = "Literature note",
    directory = "resources/literature notes",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 8,
    label = "Other",
    directory = "areas/inbox",
    ask_for_title = true,
    prefix_date = false,
  },
}

function M.templateNote()
  -- Show telescope menu to pick type
  pickers.new(opts, {
    prompt_title = "",
    finder = finders.new_table {
      results = notes_templates,
      entry_maker = function(entry)
        return {
          ordinal = entry.ordinal,
          display = entry.label,
          value = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        local title = ""
        if selection.value.ask_for_title then
          title = vim.fn.input "Title: "
        else
          title = selection.value.label
        end

        -- create note
        vim.cmd("cd " .. vim.g.zk_notebook)
        local cmd = string.format('zk new --no-input --title "%s" "%s" --print-path', title, selection.value.directory)
        local path = vim.fn.system(cmd)
        path = path:gsub("^%s*(.-)%s*$", "%1")
        if vim.fn.filereadable(path) then
          local segments = vim.split(path, "/")
          local filename = segments[#segments]
          filename = filename:gsub(".md", "")
          -- insert link
          vim.api.nvim_put({ "[[" .. filename .. "]]" }, "c", true, true)
        else
          vim.notify("File not found: " .. path, 2)
        end
      end)
      return true
    end,
  }):find()
end

function M.dailyNote()
  -- create a new note
  vim.cmd("cd " .. vim.g.zk_notebook)
  local cmd = 'zk new --no-input "resources/daily notes" --print-path'
  local path = vim.fn.system(cmd)
  path = path:gsub("^%s*(.-)%s*$", "%1")
  if vim.fn.filereadable(path) then
    vim.cmd(string.format([[execute "edit %s"]], path))
  end
end

function M.createProject(kind, title)
  -- create the project folder
  if not kind then
    kind = vim.fn.input "Type (AUDIT, SHIFT, POST, INCIDENT, TALK, ...): "
  end
  kind = string.upper(kind)
  if not title then
    title = vim.fn.input "Title: "
  end
  local date = vim.fn.strftime "%Y-%m-%d"
  local name = string.format("%s - %s - %s", date, kind, title)
  vim.fn.system(string.format('mkdir "%s/projects/%s"', vim.g.zk_notebook, name))

  -- create the project note
  vim.cmd("cd " .. vim.g.zk_notebook)
  local cmd = string.format('zk new --title "%s" --no-input "projects/%s" --print-path', name, name)
  local path = vim.fn.system(cmd)
  path = path:gsub("^%s*(.-)%s*$", "%1")
  if vim.fn.filereadable(path) then
    vim.cmd(string.format([[execute "edit %s"]], path))
  end
end

return M
