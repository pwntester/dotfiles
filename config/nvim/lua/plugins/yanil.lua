local yanil = require "yanil"
local git = require "yanil/git"
local decorators = require "yanil/decorators"
local devicons = require "nvim-web-devicons"
local canvas = require "yanil/canvas"
local Section = require "yanil/section"
local scan = require "plenary.scandir"

local open_mode = vim.loop.constants.O_CREAT + vim.loop.constants.O_WRONLY + vim.loop.constants.O_TRUNC

local function noop()
  return
end

local function iter(list_or_iter)
  if type(list_or_iter) == "function" then
    return list_or_iter
  end

  return coroutine.wrap(function()
    for i = 1, #list_or_iter do
      coroutine.yield(list_or_iter[i])
    end
  end)
end

local function reduce(list, memo, func)
  for i in iter(list) do
    memo = func(memo, i)
  end
  return memo
end

local M = {}

local function depth_indent(node)
  -- -- if not node.parent  then
  -- --   return '  '
  -- -- end
  local text = string.rep("  ", node.depth)
  return text
end

local function git_status(node)
  if not node.parent then
    return
  end

  local git_icon, git_hl = git.get_icon_and_hl(node.abs_path)
  git_icon = git_icon or " "
  -- local indent = depth_indent(node)
  -- return indent, git_hl
  return " " .. git_icon, git_hl
end

local function icon_decorator(node)
  local text = ""
  local hl = ""
  -- ﯤ
  if not node.parent then
    text = ""
    hl = "YanilTreeDirectory"
  elseif node:is_dir() then
    if node:is_link() then
      text = ""
      hl = "YanilTreeLink"
    else
      text = node.is_open and "" or ""
      hl = node:is_link() and "YanilTreeLink" or "YanilTreeDirectory"
    end
  else
    text, hl = devicons.get_icon(node.name, node.extension)
    text = text or ""
  end
  return text, hl
end

local function clear_buffer(path)
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == path then
      vim.api.nvim_command(":bwipeout! " .. buf)
    end
  end
end

local function clear_prompt()
  vim.api.nvim_command "normal :esc<CR>"
  vim.api.nvim_command "normal :esc<CR>"
end

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

-- FileSystem operations
local function create_dirs_if_needed(dirs)
  local parentDir = vim.fn.fnamemodify(dirs, ":h")
  local dir_split = vim.split(parentDir, "/")
  reduce(dir_split, "", function(directories, dir)
    directories = directories .. dir .. "/"
    local stats = vim.loop.fs_stat(directories)
    if stats == nil then
      vim.loop.fs_mkdir(directories, 493)
    end
    return directories
  end)
end

-- Move Node
local function move_node(tree, node)
  -- node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the new path for the node:"
  local msg = string.format("Rename/Move the current node \n%s \n%s", string.rep("=", 58), msg_tag)

  local original_location = node.abs_path
  local destination = vim.fn.input(msg, original_location, "file")

  clear_prompt()
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
    tree:refresh(nil, {}, function()
      tree.root:load(true)
    end)
    git.update(tree.cwd)
    tree:go_to_node(tree.root:find_node_by_path(destination))
  end)

  create_dirs_if_needed(destination)
  vim.loop.fs_rename(original_location, destination, function(err)
    if err then
      print "Could not move the files"
      return
    else
      print("Moved " .. node.name .. " successfully")
    end
    refresh()
  end)
end

-- Copy Node
local function copy_node(tree, node)
  -- node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the new path for the node:"
  local msg = string.format("Copy the node \n%s \n%s", string.rep("=", 58), msg_tag)
  local ans = vim.fn.input(msg, node.abs_path)
  clear_prompt()

  local refresh = vim.schedule_wrap(function()
    tree:refresh(nil, {}, function()
      tree.root:load(true)
    end)
    git.update(tree.cwd)
    -- tree:go_to_node(tree.root:find_node_by_path(ans))
    print("Created " .. ans .. " successfully")
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
    end
    refresh()
  end)
end

-- Reveal Node
local function reveal_in_finder(_tree, node)
  local handle
  handle = vim.loop.spawn("open", { args = { "-R", node.abs_path } }, function(code)
    handle:close()
    if code ~= 0 then
      print "error"
      return
    end
  end)
end

-- Quick Look
local function quick_look(_tree, node)
  local handle
  handle = vim.loop.spawn("qlmanage", { args = { "-p", node.abs_path } }, function(code)
    handle:close()
    if code ~= 0 then
      print "error"
      return
    end
  end)
end

-- Create Node
local function create_node(tree, node)
  node = node:is_dir() and node or node.parent
  local msg_tag = "Enter the dir/file name to be created. Dirs end with a '/'\n"
  local msg = string.format("Add a childnode \n%s \n%s", string.rep("=", 58), msg_tag)
  local ans = vim.fn.input(msg, node.abs_path)

  local refresh = vim.schedule_wrap(function()
    tree:refresh(nil, {}, function()
      tree.root:load(true)
    end)
    git.update(tree.cwd)
    tree:go_to_node(tree.root:find_node_by_path(ans))
    clear_prompt()
    print("Created " .. ans .. " successfully")
  end)

  local function file_writer(path)
    create_dirs_if_needed(path)
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
    clear_prompt()
    print "File already exists"
    return
  end

  if vim.endswith(ans, "/") then
    create_dirs_if_needed(ans)
  else
    file_writer(ans)
  end
  refresh()
end

-- Delete Node
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

  clear_prompt()
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
        clear_buffer(new_cwd)
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
    clear_buffer(node.abs_path)
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

local function find_file(tree, node)
  local winnr_bak = vim.fn.winnr()
  local altwinnr_bak = vim.fn.winnr "#"

  local cwd = node:is_dir() and node.abs_path or node.parent.abs_path

  local actions = require "telescope.actions"
  local actions_state = require "telescope.actions.state"
  require("telescope.builtin").find_files {
    cwd = cwd,
    attach_mappings = function(prompt_bufnr, _map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = actions_state.get_selected_entry()
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

-- local function default_decorator(node)
--   local text = node.name
--   local hl_group = "YanilTreeFile"
--   if node:is_dir() then
--     if not node.parent then
--       text = vim.fn.fnamemodify(node.name:sub(1, -2), ":.:t")
--       hl_group = "YanilTreeRoot"
--     else
--       hl_group = node:is_link() and "YanilTreeLink" or "YanilTreeDirectory"
--     end
--   else
--     if node:is_link() then
--       hl_group = node:is_broken() and "YanilTreeLinkBroken" or "YanilTreeLink"
--     elseif node.is_exec then
--       hl_group = "YanilTreeFileExecutable"
--     end
--   end
--   return text, hl_group
-- end

local function default_decorator(node)
  if vim.g.yanil_selected and vim.g.yanil_selected == node.abs_path then
    return node.name, "CursorLineNr"
  end
  return decorators.default(node)
end

local yanilBuffers = Section:new {
  name = "Buffers",
  total_lines = 2,
}

function yanilBuffers:get_buffers()
  local buffers = {}
  local bufnrs = vim.tbl_filter(function(buf)
    if 1 ~= vim.fn.buflisted(buf) then
      return false
    end
    if buf == canvas.bufnr then
      return false
    end
    if not vim.api.nvim_buf_is_loaded(buf) then
      return false
    end
    if buf == vim.api.nvim_get_current_buf() then
      return false
    end

    return true
  end, vim.api.nvim_list_bufs())
  for _, bufnr in ipairs(bufnrs) do
    local element = {
      bufnr = bufnr,
      name = vim.fn.getbufinfo(bufnr)[1].name,
    }
    table.insert(buffers, element)
  end
  return buffers
end

function yanilBuffers:draw()
  local bufs = yanilBuffers:get_buffers()
  local lines = { "Buffers" }
  for _, buf in ipairs(bufs) do
    table.insert(lines, buf.name)
  end
  -- self.total_lines = #lines
  return { texts = { line_start = 0, line_end = #lines, lines = lines } }
end

function yanilBuffers:total_lines()
  return 2
  -- return yanilBuffers.total_lines
end

yanil.setup {
  git = {
    icons = {
      Unstaged = "●",
      Staged = "●",
      Unmerged = "●",
      Renamed = "●",
      Untracked = "U",
      Modified = "M",
      Deleted = "●",
      Dirty = "●",
      Ignored = "●",
      Clean = "●",
      Unknown = "●",
    },
  },
}

M.tree = require("yanil/sections/tree"):new()
M.tree:setup {
  draw_opts = {
    decorators = {
      depth_indent,
      icon_decorator,
      decorators.space,
      default_decorator,
      --default_decorator,
      decorators.readonly,
      decorators.executable,
      decorators.link_to,
      git_status,
    },
  },
  filters = {
    function(name)
      local patterns = { "^%.git$", "%.pyc", "^__pycache__$", "^%.idea$", "^%.iml$", "^%.DS_Store$", "%.o$", "%.d$" }
      for _, pat in ipairs(patterns) do
        if string.find(name, pat) then
          return true
        end
      end
    end,
  },
  keymaps = {
    ["]c"] = git.jump_next,
    ["[c"] = git.jump_prev,
    ["o"] = expand_collapase_node,
    ["A"] = create_node,
    ["D"] = delete_node,
    ["M"] = move_node,
    ["<tab>"] = toggle_zoom,
    ["C"] = copy_node,
    ["U"] = noop,
    ["K"] = function()
      vim.api.nvim_feedkeys("5k", "n", true)
    end,
    ["J"] = function()
      vim.api.nvim_feedkeys("5j", "n", true)
    end,
    ["/"] = find_file,
    ["R"] = refresh_and_focus,
    ["r"] = reveal_in_finder,
    --["<space>"] = quick_look,
    ["P"] = function(tree, node)
      if not node.parent then
        return
      end
      tree:go_to_node(node.parent)
    end,
  },
}

canvas.register_hooks {
  on_leave = function()
    vim.wo.cursorline = false
  end,
  on_open = function(_cwd)
    local buffers = yanilBuffers:get_buffers()
    local entries = scan.scan_dir(M.tree.cwd)
    if M.tree.cwd then
      for _, buffer in ipairs(buffers) do
        for _, entry in ipairs(entries) do
          entry = entry:gsub("//", "/")
          if entry == buffer.name then
            local node = M.tree.root:find_node_by_path(entry)
            M.tree:go_to_node(node)
          end
        end
      end
      git.update(M.tree.cwd)
    end
  end,
  on_enter = function()
    vim.api.nvim_command "doautocmd User YanilTreeEnter"
    vim.wo.cursorline = true
    vim.cmd "hi YanilGitUntracked gui=None guifg=#65737e"
    vim.cmd "hi YanilTreeDirectory guifg=#6699cc"
    vim.cmd "hi YanilTreeLinkTo guibg=none"
    vim.cmd "hi YanilTreeFile guibg=none"
    vim.cmd "setl nowrap"
    vim.cmd "silent vertical resize 45"

    -- show opened buffers
    local buffers = yanilBuffers:get_buffers()
    local entries = scan.scan_dir(M.tree.cwd)
    if M.tree.cwd then
      for _, buffer in ipairs(buffers) do
        for _, entry in ipairs(entries) do
          entry = entry:gsub("//", "/")
          if entry == buffer.name then
            local node = M.tree.root:find_node_by_path(entry)
            if node then
              M.tree:go_to_node(node)
            end
          end
        end
      end

      -- update git
      git.update(M.tree.cwd)
    end
  end,
  -- on_exit()
}

canvas.setup {
  --yanilBuffers,
  sections = { M.tree },
  autocmds = {
    {
      event = "User",
      pattern = "YanilGitStatusChanged",
      cmd = function()
        git.refresh_tree(M.tree)
      end,
    },
  },
}

function M.set_selected_node()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.fn.getbufinfo(bufnr)[1].name
  if vim.loop.fs_stat(path) then
    vim.g.yanil_selected = path

    -- try updating the tree
    if M.tree and M.tree.root then
      local node = M.tree.root:find_node_by_path(path)
      if node then
        --M.tree:force_refresh_node(node)
        M.tree:force_refresh_tree()
      end
    end
  end
end

vim.cmd [[augroup yanil_tree]]
vim.cmd [[au!]]
vim.cmd [[autocmd BufEnter * lua require"plugins.yanil".set_selected_node()]]
vim.cmd [[augroup END]]

return M
