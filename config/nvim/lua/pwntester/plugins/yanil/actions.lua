local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local tactions = require "telescope.actions"
local taction_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local scan = require "plenary.scandir"
local git = require "yanil/git"
local utils = require "pwntester.plugins.yanil.utils"

local function noop()
  return
end

-- Toggle zoom
local function toggle_zoom()
  vim.b.oldWindowSize = vim.b.oldWindowSize or vim.api.nvim_win_get_width(0)
  if vim.b.nvimTreeIsZoomed then
    vim.b.nvimTreeIsZoomed = false
    vim.cmd("silent vertical resize" .. vim.b.oldWindowSize)
  else
    vim.b.nvimTreeIsZoomed = true
    vim.cmd "silent vertical resize"
  end
end

-- Reveal node
local function reveal_node(_, node)
  local handle
  handle = vim.loop.spawn("open", { args = { "-R", node.abs_path } }, function(code)
    handle:close()
    if code ~= 0 then
      print "error"
      return
    end
  end)
end

local function find_file(tree, node)
  local winnr_bak = vim.fn.winnr()
  local altwinnr_bak = vim.fn.winnr "#"

  local cwd = node:is_dir() and node.abs_path or node.parent.abs_path

  require("telescope.builtin").find_files {
    cwd = cwd,
    attach_mappings = function(prompt_bufnr)
      tactions.select_default:replace(function()
        tactions.close(prompt_bufnr)
        local selection = taction_state.get_selected_entry()
        local path = selection.cwd .. selection[1]
        local target = tree.root:find_node_by_path(path)
        if not node then
          print("file", path, "is not found or ignored")
          return
        end
        tree:go_to_node(target)

        vim.cmd(string.format([[execute "%dwincmd w"]], altwinnr_bak))
        vim.cmd(string.format([[execute "%dwincmd w"]], winnr_bak))
      end)
      return true
    end,
  }
end

-- Refresh tree
local function refresh_and_focus(tree, node)
  tree:refresh(nil, {}, function()
    tree.root:load(true)
  end)
  git.update(tree.cwd)
  tree:go_to_node(tree.root:find_node_by_path(node.abs_path))
end

-- Expand or collapse directory
local function expand_collapase_node(tree, node)
  node = node:is_dir() and node or node.parent
  tree:refresh(node, {}, function()
    node:toggle()
  end)
  tree:go_to_node(node) -- move cursor. (not necessary)
end

-- Move node
local function move_node(tree, node)
  local cwd = tree.cwd
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
        local source_file = node.abs_path
        local target_dir = cwd .. selection[1]
        target_dir = target_dir .. "/"
        target_dir = target_dir:gsub("//", "/")
        local target_file = target_dir .. node.name
        local target_node = tree.root:find_node_by_path(target_dir)
        if not target_node or not target_node:is_dir() then
          vim.notify "Target is not a directory"
          return
        end

        local refresh = vim.schedule_wrap(function()
          tree:force_refresh_tree()
          git.update(tree.cwd)
          tree:go_to_node(tree.root:find_node_by_path(target_file))
        end)

        vim.loop.fs_rename(source_file, target_file, function(err)
          if err then
            print "Could not move the file"
            return
          else
            print("Moved " .. node.name .. " successfully")
            refresh()
          end
        end)
      end)
      return true
    end,
  }):find()
end

-- Rename node
local function rename_node(tree, node)
  -- node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the new path for the node:"
  local msg = string.format("Rename the current node \n%s \n%s", string.rep("=", 58), msg_tag)

  local original_location = node.abs_path
  local destination = vim.fn.input(msg, original_location, "file")

  utils.clear_prompt()
  -- If cancelled
  if not destination or destination == "" then
    print "Operation cancelled"
    return
  end

  -- If aleady exists
  if vim.loop.fs_stat(destination) then
    print(destination, "is already exists")
    return
  end

  local refresh = vim.schedule_wrap(function()
    tree:force_refresh_tree()
    git.update(tree.cwd)
    tree:go_to_node(tree.root:find_node_by_path(destination))
  end)

  utils.create_dirs_if_needed(destination)
  vim.loop.fs_rename(original_location, destination, function(err)
    if err then
      print "Could not rename the files"
      return
    else
      print("Renamed " .. node.name .. " successfully")
      refresh()
    end
  end)
end

-- Copy Node
local function copy_node(tree, node)
  -- node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the new path for the node:"
  local msg = string.format("Copy the node \n%s \n%s", string.rep("=", 58), msg_tag)
  local ans = vim.fn.input(msg, node.abs_path)
  utils.clear_prompt()

  local refresh = vim.schedule_wrap(function()
    tree:force_refresh_tree()
    git.update(tree.cwd)
    tree:go_to_node(tree.root:find_node_by_path(ans))
  end)

  if not ans or ans == "" then
    return
  end
  if vim.loop.fs_stat(ans) then
    print "Node already exists"
    return
  end

  vim.loop.fs_copyfile(node.abs_path, ans)
  local handle
  handle = vim.loop.spawn("cp", { args = { "-r", node.abs_path, ans } }, function(code)
    handle:close()
    if code ~= 0 then
      print "copy failed"
      return
    else
      refresh()
      print("Created " .. ans .. " successfully")
    end
  end)
end

-- Create node
local function create_node(tree, node)
  node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the dir/file name to be created. Dirs end with a '/'\n"
  local msg = string.format("Add a childnode \n%s \n%s", string.rep("=", 58), msg_tag)
  local ans = vim.fn.input(msg, node.abs_path)

  local refresh = vim.schedule_wrap(function()
    tree:force_refresh_tree()
    git.update(tree.cwd)
    tree:go_to_node(tree.root:find_node_by_path(ans))
    utils.clear_prompt()
  end)

  local function file_writer(path)
    utils.create_dirs_if_needed(path)
    local open_mode = vim.loop.constants.O_CREAT + vim.loop.constants.O_WRONLY + vim.loop.constants.O_TRUNC
    local fd = vim.loop.fs_open(path, "w", open_mode)
    if not fd then
      vim.api.nvim_err_writeln("Could not create file " .. path)
      return
    end
    vim.loop.fs_chmod(path, 420)
    vim.loop.fs_close(fd)
  end

  if not ans or ans == "" then
    return
  end
  if vim.loop.fs_stat(ans) then
    utils.clear_prompt()
    print "File already exists"
    return
  end

  if vim.endswith(ans, "/") then
    utils.create_dirs_if_needed(ans)
  else
    file_writer(ans)
  end
  refresh()
  print("Created " .. ans .. " successfully")
end

-- Open node
local function open_node(tree, node)
  local cmd = "e"
  if node:is_dir() then
    return
  end

  local yanil_winid = vim.api.nvim_get_current_win()
  local target_id = utils.pick_window(yanil_winid)
  vim.api.nvim_set_current_win(target_id)
  --vim.api.nvim_command "wincmd p"
  vim.api.nvim_command(cmd .. " " .. node.abs_path)
end

-- Delete node
local function delete_node(tree, node)
  if node == tree.root then
    return
  end

  if node:is_dir() then
    node:load()
  end

  local msg_tag = string.format("Are you sure you want to delete (y/n) \n%s: ", node.abs_path)

  if node:is_dir() and #node.entries > 0 then
    msg_tag = "Warning, directory is not empty \n" .. msg_tag
  end

  local msg = string.format("Delete the current node \n%s \n%s", string.rep("=", 58), msg_tag)
  local answer = vim.fn.input(msg)

  utils.clear_prompt()
  if answer:lower() ~= "y" then
    print "Operation cancelled"
    return
  end

  local function delete_dir(cwd)
    local handle = vim.loop.fs_scandir(cwd)
    if type(handle) == "string" then
      return vim.api.nvim_err_writeln(handle)
    end

    while true do
      local name, t = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end

      local new_cwd = cwd .. "/" .. name
      if t == "directory" then
        local success = delete_dir(new_cwd)
        if not success then
          print("failed to delete ", new_cwd)
          return false
        end
      else
        utils.clear_buffer(new_cwd)
        local success = vim.loop.fs_unlink(new_cwd)
        if not success then
          return false
        end
      end
    end
    return vim.loop.fs_rmdir(cwd)
  end

  if node.entries then
    local success = delete_dir(node.abs_path:sub(1, -2))
    if not success then
      return vim.api.nvim_err_writeln("Could not remove " .. node.name)
    end
  else
    local success = vim.loop.fs_unlink(node.abs_path)
    if not success then
      return vim.api.nvim_err_writeln("Could not remove " .. node.name)
    end
    utils.clear_buffer(node.abs_path)
  end

  local next_node = tree:find_neighbor(node, -1)
  local path = next_node.abs_path
  local refresh = vim.schedule_wrap(function()
    tree:refresh(tree.root, {}, function()
      git.update(tree.cwd)
      tree.root:load(true)
    end)
    tree:go_to_node(tree.root:find_node_by_path(path))
    print("Deleted " .. node.name .. " successfully")
  end)
  refresh()
end

local function go_to_parent(tree, node)
  if not node.parent then
    return
  end
  tree:go_to_node(node.parent)
end

local function highlight_node(tree)
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.fn.getbufinfo(bufnr)[1].name
  if vim.loop.fs_stat(path) then
    vim.g.yanil_selected = path
    if tree and tree.root then
      local node = tree.root:find_node_by_path(path)
      if node then
        tree:go_to_node(node)
        tree:force_refresh_tree()
      end
    end
  end
end

return {
  expand_collapase_node = expand_collapase_node,
  open_node = open_node,
  create_node = create_node,
  delete_node = delete_node,
  rename_node = rename_node,
  move_node = move_node,
  toggle_zoom = toggle_zoom,
  copy_node = copy_node,
  noop = noop,
  find_file = find_file,
  refresh_and_focus = refresh_and_focus,
  reveal_node = reveal_node,
  go_to_parent = go_to_parent,
  git_next = git.jump_next,
  git_prev = git.jump_prev,
  highlight_node = highlight_node,
}
