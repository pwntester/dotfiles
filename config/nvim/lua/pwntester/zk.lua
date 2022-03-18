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
    label = "SecLab team meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "SecLab research targeting meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "PSE sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "Product sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "CodeQL sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "CodeScanning sync meeting",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "1-on-1 with Xavier",
    directory = "resources/meeting notes",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    label = "Other meeting",
    directory = "resources/meeting notes",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    label = "Literature note",
    directory = "resources/literature notes",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    label = "Other note",
    directory = "areas/inbox",
    ask_for_title = true,
    prefix_date = false,
  },
  {
    label = "New project",
    directory = "projects",
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
          ordinal = entry.label,
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

        -- create project
        if selection.value.label == "New project" then
          local name = M.createProject()
          -- insert link
          vim.api.nvim_put({ "[[" .. name .. "]]" }, "c", true, true)
          return
        end

        -- create note
        local title = ""
        if selection.value.ask_for_title then
          title = vim.fn.input "Title: "
        else
          title = selection.value.label
        end
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
    vim.cmd("edit " .. path)
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
  vim.fn.system(string.format('zk new --title "%s" --no-input "projects/%s" --print-path', name, name))

  return name
end

return M
