function NavigationFloatingWin()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.min(math.ceil(height * 3 / 4), 30)
  local win_width = math.ceil(width * 0.9)

  if (width < 150) then win_width = math.ceil(width - 8) end

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.ceil((height - win_height) / 2),
    col = math.ceil((width - win_width) / 2)
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
end

function Terminal(nr, ...)
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.min(math.ceil(height * 3 / 4), 30)
  local win_width = math.ceil(width * 0.9)

  if (width < 150) then win_width = math.ceil(width - 8) end

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.ceil((height - win_height) / 2),
    col = math.ceil((width - win_width) / 2)
  }

  local buf = vim.api.nvim_create_buf(true, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_call_function("termopen", {"/bin/zsh"})
  vim.api.nvim_buf_set_name(buf, "my-term-" .. nr)
  vim.api.nvim_command('startinsert')
  --vim.api.nvim_call_function("mode", {"insert"})
  --vim.api.nvim_set_buf()
  --vim.api.nvim_buf_set_lines(buf, 0, 2, false, { "a", "2" })
end
