local M = {}

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

function M.clear_buffer(path)
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == path then
      vim.api.nvim_command(":bwipeout! " .. buf)
    end
  end
end

function M.clear_prompt()
  vim.api.nvim_command "normal :esc<CR>"
  vim.api.nvim_command "normal :esc<CR>"
end

function M.create_dirs_if_needed(dirs)
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

function M.get_buffers()
  local all_bufnrs = vim.api.nvim_list_bufs()
  local bufnrs = vim.tbl_filter(function(buf)
    if 1 ~= vim.fn.buflisted(buf) then
      return false
    end
    if vim.bo[buf].filetype == "Yanil" then
      return false
    end
    if not vim.api.nvim_buf_is_loaded(buf) then
      return false
    end
    if buf == vim.api.nvim_get_current_buf() then
      return false
    end

    return true
  end, all_bufnrs)

  local buffers = {}
  for _, bufnr in ipairs(bufnrs) do
    local element = {
      bufnr = bufnr,
      name = vim.fn.getbufinfo(bufnr)[1].name,
    }
    table.insert(buffers, element)
  end
  return buffers
end

local special_buffers = {
  filetype = {
    "help",
    "fortifytestpane",
    "fortifyauditpane",
    "qf",
    "goterm",
    "codeql_panel",
    "codeql_explorer",
    "terminal",
    "packer",
    "NvimTree",
    "octo",
    "octo_panel",
    "aerieal",
    "Trouble",
    "dashboard",
    "frecency",
    "TelescopePrompt",
    "TelescopeResults",
    "NeogitStatus",
    "notify",
  },
}

---Get user to pick a window. Selectable windows are all windows in the current
---tabpage that aren't NvimTree.
---@return integer|nil -- If a valid window was picked, return its id. If an
---       invalid window was picked / user canceled, return nil. If there are
---       no selectable windows, return -1.
--- from: https://github.com/kyazdani42/nvim-tree.lua/blob/master/lua/nvim-tree/lib.lua
function M.pick_window(panel_winid)
  local tabpage = vim.api.nvim_get_current_tabpage()
  local win_ids = vim.api.nvim_tabpage_list_wins(tabpage)
  local exclude = special_buffers

  local selectable = vim.tbl_filter(function(id)
    local bufid = vim.api.nvim_win_get_buf(id)
    for option, v in pairs(exclude) do
      local ok, option_value = pcall(vim.api.nvim_buf_get_option, bufid, option)
      if ok and vim.tbl_contains(v, option_value) then
        return false
      end
    end

    local win_config = vim.api.nvim_win_get_config(id)
    return id ~= panel_winid and win_config.focusable and not win_config.external
  end, win_ids)

  -- If there are no selectable windows: return. If there's only 1, return it without picking.
  if #selectable == 0 then
    return -1
  end
  if #selectable == 1 then
    return selectable[1]
  end

  local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

  local i = 1
  local win_opts = {}
  local win_map = {}
  local laststatus = vim.o.laststatus
  vim.o.laststatus = 2

  -- Setup UI
  for _, id in ipairs(selectable) do
    local char = chars:sub(i, i)
    local ok_status, statusline = pcall(vim.api.nvim_win_get_option, id, "statusline")
    local ok_hl, winhl = pcall(vim.api.nvim_win_get_option, id, "winhl")

    win_opts[id] = {
      statusline = ok_status and statusline or "",
      winhl = ok_hl and winhl or "",
    }
    win_map[char] = id

    vim.api.nvim_win_set_option(id, "statusline", "%=" .. char .. "%=")
    vim.api.nvim_win_set_option(id, "winhl", "StatusLine:CodeQLWindowPicker,StatusLineNC:CodeQLWindowPicker")

    i = i + 1
    if i > #chars then
      break
    end
  end

  vim.cmd "redraw"
  print "Pick window: "
  local _, resp = pcall(M.get_user_input_char)
  resp = (resp or ""):upper()
  -- clears prompt
  vim.api.nvim_command "normal! :"

  -- Restore window options
  for _, id in ipairs(selectable) do
    for opt, value in pairs(win_opts[id]) do
      vim.api.nvim_win_set_option(id, opt, value)
    end
  end

  vim.o.laststatus = laststatus

  return win_map[resp]
end

return M
