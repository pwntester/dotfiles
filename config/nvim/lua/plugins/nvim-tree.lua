local luv = vim.loop
local lib = require "nvim-tree.lib"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local scan = require "plenary.scandir"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

local function is_dir(name)
  local stats = luv.fs_stat(name)
  return stats and stats.type == 'directory'
end

local function telescope_move()
  local node = lib.get_node_at_cursor()
  local cwd = lib.Tree.cwd
  local dirs = scan.scan_dir(cwd, { only_dirs = true })
  local relative_dirs = {}
  for _, dir in ipairs(dirs) do
    local relative_dir = dir:gsub(cwd, "")
    table.insert(relative_dirs, relative_dir)
  end

  local opts = require("telescope.themes").get_dropdown{}
  pickers.new(opts, {
    prompt_title = "Target directory",
    finder = finders.new_table {
      results = relative_dirs
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local source_file = node.absolute_path
        local target_dir = cwd..selection[1]
        if not is_dir(target_dir) then
          vim.notify("Target is not a directory")
          return
        end
        os.execute(string.format("mv %s %s", vim.fn.shellescape(source_file), vim.fn.shellescape(target_dir)))
        lib.refresh_tree()
        --lib.change_dir(vim.fn.fnamemodify(target_dir, ':p:h'))
        --lib.set_index_and_redraw(target_dir)
      end)
      return true
    end,
  }):find()
end

local function setup()
  vim.g.nvim_tree_respect_buf_cwd = 1
  vim.g.nvim_tree_hide_dotfiles = 1
  vim.g.nvim_tree_ignore = {".DS_Store", ".git"}
  vim.g.nvim_tree_highlight_opened_files = 1
  vim.g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 1,
    folder_arrows = 1,
  }
  vim.g.nvim_tree_window_picker_exclude = {
    ["filetype"] = { 'packer', 'qf' },
    ["buftype"] =  { 'terminal' },
  }
  vim.g.nvim_tree_special_files = {}

  require'nvim-tree'.setup({
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = true,
    ignore_ft_on_setup  = g.special_buffers,
    update_to_buf_dir   = {
      enable = true,
      auto_open = true,
    },
    auto_close          = false,
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = true,
    update_focused_file = {
      enable      = true,
      update_cwd  = true,
      ignore_list = {}
    },
    system_open = {
      cmd  = nil,
      args = {}
    },
    view = {
      width = 40,
      height = 30,
      side = 'left',
      auto_resize = false,
      mappings = {
        custom_only = false,
        list = {
          {
            key = "m",
            mode = "n",
            cb = ":lua require'plugins.nvim-tree'.telescope_move()<CR>"
          },
          {
            key = "h",
            cb = tree_cb("toggle_dotfiles")
          },
        }
      }
    }
  })
end
return {
  setup = setup;
  telescope_move = telescope_move;
}
