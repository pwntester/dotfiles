function BorderedFloatingWin()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.min(math.ceil(height * 2 / 3), 30)
  local win_width = math.ceil(width * 0.7)
  --local win_height = math.min(math.ceil(height * 3 / 4), 30)
  --local win_width = math.ceil(width * 0.9)

  if (width < 150) then win_width = math.ceil(width - 8) end

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.ceil((height - win_height) / 2),
    col = math.ceil((width - win_width) / 2),
    style = 'minimal'
  }

  local top = "╭"..string.rep("─", win_width - 2).."╮"
  local mid = "│"..string.rep(" ", win_width - 2).."│"
  local bot = "╰"..string.rep("─", win_width - 2).."╯"
  local lines = { top }
  for i=1,win_height-2 do
    table.insert(lines, mid)
  end
  table.insert(lines, bot)

  local border_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, true, lines)
  local border_win = vim.api.nvim_open_win(border_buf, true, opts)
  vim.api.nvim_win_set_option(border_win, "winhighlight", "Normal:Normal")
  vim.api.nvim_win_set_option(border_win, 'wrap', false)
  vim.api.nvim_win_set_option(border_win, 'number', false)
  vim.api.nvim_win_set_option(border_win, 'relativenumber', false)
  vim.api.nvim_win_set_option(border_win, 'signcolumn', 'no')
  opts.row = opts.row + 1
  opts.height = opts.height - 2
  opts.col = opts.col + 2
  opts.width = opts.width - 4
  vim.api.nvim_command("au BufWipeout <buffer> exe 'bw '"..border_buf)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_option(win, 'signcolumn', 'no')

end

function FloatingWin()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.min(math.ceil(height * 2 / 3), 30)
  local win_width = math.ceil(width * 0.7)
  --local win_height = math.min(math.ceil(height * 3 / 4), 30)
  --local win_width = math.ceil(width * 0.9)

  if (width < 150) then win_width = math.ceil(width - 8) end

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.ceil((height - win_height) / 2),
    col = math.ceil((width - win_width) / 2),
    style = 'minimal'
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(border_win, "winhighlight", "Normal:Normal")
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_option(win, 'signcolumn', 'no')

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

