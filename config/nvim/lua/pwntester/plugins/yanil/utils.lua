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

return M
