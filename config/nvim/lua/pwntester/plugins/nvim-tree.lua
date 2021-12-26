local luv = vim.loop
local lib = require "nvim-tree.lib"
local scan = require "plenary.scandir"
local tree_cb = require("nvim-tree.config").nvim_tree_callback
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local function is_dir(name)
  local stats = luv.fs_stat(name)
  return stats and stats.type == "directory"
end

local function open_collapse()
  local node = lib.get_node_at_cursor()
  if is_dir(node.absolute_path) then
    lib.expand_or_collapse(node)
  else
    lib.close_node(node)
  end
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

  local opts = require("telescope.themes").get_dropdown {}
  pickers.new(opts, {
    prompt_title = "Target directory",
    finder = finders.new_table {
      results = relative_dirs,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local source_file = node.absolute_path
        local target_dir = cwd .. selection[1]
        if not is_dir(target_dir) then
          vim.notify "Target is not a directory"
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
  -- hide the windline when picking a window
  -- https://github.com/windwp/windline.nvim/issues/21#issuecomment-953386547
  local treeutils = require "nvim-tree.utils"
  local fl = require "wlfloatline"
  _G._tree_get_user_input_char = _G._tree_get_user_input_char or treeutils.get_user_input_char
  treeutils.get_user_input_char = function()
    fl.floatline_hide()
    local char = _G._tree_get_user_input_char()
    fl.floatline_on_resize()
    return char
  end

  require("nvim-tree").setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = g.special_buffers,
    auto_close = false,
    open_on_tab = false,
    hijack_cursor = false,
    -- changes the tree root directory to the buffer one
    update_cwd = true,
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
      enable = true,
      -- update the root directory of the tree to the one of the folder containing the file
      -- if the file is not under the current root directory.
      update_cwd = false,
      ignore_list = {},
    },
    -- hijacks new directory buffers when they are opened (`:e dir`).
    update_to_buf_dir = {
      enable = false,
      auto_open = false,
    },
    system_open = {
      cmd = nil,
      args = {},
    },
    filters = {
      dotfiles = true,
      custom = { ".DS_Store", ".git" },
    },
    view = {
      width = 40,
      height = 30,
      side = "left",
      auto_resize = false,
      mappings = {
        custom_only = false,
        list = {
          { key = "m", mode = "n", cb = ":lua require'pwntester.plugins.nvim-tree'.telescope_move()<CR>" },
          { key = "h", mode = "n", cb = tree_cb "toggle_dotfiles" },
          { key = "o", mode = "n", cb = ":lua require'pwntester.plugins.nvim-tree'.open_collapse()<CR>" },
        },
      },
    },
  }
end
return {
  setup = setup,
  telescope_move = telescope_move,
  open_collapse = open_collapse,
}
