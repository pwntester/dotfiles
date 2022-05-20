local highlights = require "neo-tree.ui.highlights"
local scan = require "plenary.scandir"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local tactions = require "telescope.actions"
local taction_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local manager = require "neo-tree.sources.manager"
local cc = require("neo-tree.sources.common.commands")
local fs = require("neo-tree.sources.filesystem")
local utils = require("neo-tree.utils")

local M = {}

local function is_dir(name)
  local stats = vim.loop.fs_stat(name)
  return stats and stats.type == "directory"
end

function M.setup()
  require("neo-tree").setup {
    enable_diagnostics = false,
    filesystem = {
      follow_current_file = true,
      use_libuv_file_watcher = true,
      components = {
        icon = function(config, node)
          local icon = config.default or " "
          local padding = config.padding or " "
          local highlight = config.highlight or highlights.FILE_ICON
          if node.type == "directory" then
            highlight = highlights.DIRECTORY_ICON
            if node:is_expanded() then
              icon = config.folder_open or "-"
            else
              icon = config.folder_closed or "+"
            end
          elseif node.type == "file" then
            local success, web_devicons = pcall(require, "nvim-web-devicons")
            if success then
              local devicon, hl = web_devicons.get_icon(node.name, node.ext)
              icon = devicon or icon
              highlight = hl or highlight
            end
          end
          if node:get_depth() == 1 then
            icon = ""
          end
          return {
            text = icon .. padding,
            highlight = highlight,
          }
        end,
        name = function(config, node)
          local name = node.name
          local highlight = config.highlight or highlights.FILE_NAME
          if node.type == "directory" then
            highlight = highlights.DIRECTORY_NAME
            name = name .. "/"
          end
          if node:get_depth() == 1 then
            highlight = highlights.ROOT_NAME
          end
          return {
            text = name,
            highlight = highlight,
          }
        end,
        git_status = function(config, node, state)
          local git_status_lookup = state.git_status_lookup
          if not git_status_lookup then
            return {}
          end
          local git_status = git_status_lookup[node.path]
          if not git_status then
            return {}
          end

          local highlight = highlights.FILE_NAME
          if git_status:match "?$" then
            highlight = highlights.GIT_UNTRACKED
          elseif git_status:match "U" then
            highlight = highlights.GIT_CONFLICT
          elseif git_status == "AA" then
            highlight = highlights.GIT_CONFLICT
          elseif git_status:match "M" then
            highlight = highlights.GIT_MODIFIED
          elseif git_status:match "[ACRT]" then
            highlight = highlights.GIT_ADDED
          end

          return {
            text = " ●",
            highlight = config.highlight or highlight,
          }
        end,
      },
      window = {
        mappings = {
          ["<CR>"] = function(state)
            local node = state.tree:get_node()
            if vim.endswith(node.path, ".sarif") then
              vim.api.nvim_command("LoadSarif " .. node.path)
            else
              cc.open_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
            end
          end,
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["o"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              local parent_node = state.tree:get_node(node:get_parent_id())
              require("neo-tree.sources.filesystem").toggle_directory(state, parent_node)
            end
          end,
          ["m"] = function(state)
            local node = state.tree:get_node()
            local tree = state.tree
            local cwd = manager.get_cwd(state)
            local dirs = scan.scan_dir(cwd, { only_dirs = true })
            local relative_dirs = {}
            for _, dir in ipairs(dirs) do
              local relative_dir = dir:gsub(cwd, "")
              table.insert(relative_dirs, relative_dir)
            end

            local opts = require("telescope.themes").get_dropdown {}
            pickers.new(opts, {
              prompt_title = "Target directory",
              finder = finders.new_table {
                results = relative_dirs,
              },
              sorter = conf.generic_sorter(opts),
              attach_mappings = function(prompt_bufnr)
                tactions.select_default:replace(function()
                  tactions.close(prompt_bufnr)
                  local selection = taction_state.get_selected_entry()

                  local source_file = node.path
                  local target_dir = cwd .. selection[1]
                  target_dir = target_dir .. "/"
                  target_dir = target_dir:gsub("//", "/")
                  local target_file = target_dir .. node.name

                  if not is_dir(target_dir) then
                    vim.notify "Target is not a directory"
                    return
                  end

                  vim.loop.fs_rename(
                    source_file,
                    target_file,
                    vim.schedule(function(err)
                      if err then
                        print "Could not move the file"
                        return
                      else
                        print("Moved " .. node.name .. " successfully")
                        tree:render()
                      end
                    end)
                  )
                end)
                return true
              end,
            }):find()
          end,
        },
      },
    },
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        with_markers = false,
        indent_marker = " ",
        last_indent_marker = " ",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "ﰊ",
        default = "*",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = false,
      },
      git_status = {
        highlight = "ErrorMsg",
      },
    },
  }
end

return M
