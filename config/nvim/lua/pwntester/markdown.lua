local M = {}

function M.insertCheckbox()
  vim.api.nvim_put({ "[ ] " }, "c", true, true)
end

function M.pasteLink()
  -- get the contents of the system clipboard
  local url = vim.fn.getreg "*"
  local link = string.format("[](%s)", url)
  -- get cursor position
  local cursor = vim.fn.getpos "."
  -- insert link
  vim.api.nvim_put({ link }, "c", true, true)
  -- move the cursor to `[_](link)`
  vim.fn.setpos(".", { cursor[1], cursor[2], cursor[3] + 1, cursor[4] })
end

function M.pasteImage(dir)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle = nil

  local function on_read(err, _)
    if err then
      print("ERROR: ", err)
    end
  end

  local uuid = vim.fn.trim(vim.fn.system "uuidgen")
  uuid = string.gsub(uuid, "\n+$", "")
  dir = string.format("%s/%s", vim.fn.expand "%:p:h", dir)
  if vim.fn.isdirectory(dir) then
    print(dir)
    vim.fn.mkdir(dir, "p")
  end
  local cmd = string.format("pngpaste %s/%s.png", dir, uuid)

  handle = vim.loop.spawn(
    "sh",
    {
      args = { "-c", cmd },
      stdio = { stdout, stderr },
    },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      if not handle:is_closing() then
        handle:close()
      end
      local img = string.format("%s/%s.png", dir, uuid)
      local link = string.format("![](%s)", img)
      local line = vim.fn.getline "."
      vim.fn.setline(
        ".",
        vim.fn.strpart(line, 0, vim.fn.col "." - 1) .. link .. vim.fn.strpart(line, vim.fn.col "." - 1)
      )
    end)
  )
  vim.loop.read_start(stdout, on_read)
  vim.loop.read_start(stderr, on_read)
end

function M.asyncPush()
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle = nil

  local function on_read(err, _)
    if err then
      print("ERROR: ", err)
    end
  end

  local cmd_str = 'git add "%s" ;git commit -m "Auto commit of %s" "%s";git push;'
  local cmd = string.format(cmd_str, vim.fn.expand "%", vim.fn.expand "%:t", vim.fn.expand "%")

  --print('AutoCommiting changes ...')
  handle = vim.loop.spawn(
    "sh",
    {
      args = { "-c", cmd },
      stdio = { stdout, stderr },
    },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      if not handle:is_closing() then
        handle:close()
      end
      vim.notify "Pushed changes to GitHub"
    end)
  )
  vim.loop.read_start(stdout, on_read)
  vim.loop.read_start(stderr, on_read)
end

function M.markdownBlocks()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  pcall(vim.api.nvim_command, "sign unplace * file=" .. vim.fn.expand "%")

  local continue = false
  -- iterate through each line in the buffer
  for lnum = 1, #vim.fn.getline(1, "$"), 1 do
    -- detect the start fo a code block
    local line = vim.fn.getline(lnum)
    if (not continue and string.match(line, "^%s*```.*$")) or (not string.match(line, "^%s*```.*$") and continue) then
      -- continue placing signs, until the block stops
      continue = true
      -- place sign
      pcall(
        vim.api.nvim_command,
        "sign place " .. lnum .. " line=" .. lnum .. " name=codeblock file=" .. vim.fn.expand "%"
      )
    elseif string.match(line, "^%s*```%s*") and continue then
      -- place sign
      pcall(
        vim.api.nvim_command,
        "sign place " .. lnum .. " line=" .. lnum .. " name=codeblock file=" .. vim.fn.expand "%"
      )
      -- stop placing signs
      continue = false
    end
  end
end

-- add/remove list bullets
function M.toggleBullets()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  local newlines = {}
  local lines = vim.fn.getline(line_start, line_end)
  for _, line in ipairs(lines) do
    -- if line starts with a bullet (`-`), remove it
    if string.match(line, "^%s*%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1")))
      -- is line does not start with a bullet, add it
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
end

-- add/remove checkbox
function M.toggleCheckboxes()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  local newlines = {}
  local lines = vim.fn.getline(line_start, line_end)
  for _, line in ipairs(lines) do
    -- if line starts with an todo checkbox (`- [ ]`), toggle it (`- [x]`)
    if string.match(line, "^(%s*)%-%s%[%s%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[%s%]%s", "%1- [x] ")))
      -- if line starts with an done checkbox (`- [x]`), remove checkbox (`- `)
    elseif string.match(line, "^(%s*)%-%s%[x%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[x%]%s", "%1- ")))
      -- if line starts with a bullet (`- `), add an empty checkbox (`- [ ]`)
    elseif string.match(line, "^(%s*)%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1- [ ] ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
end

-- add/remove bullets
function M.toggleEntries()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  local newlines = {}
  local lines = vim.fn.getline(line_start, line_end)
  for _, line in ipairs(lines) do
    -- if line starts with an todo checkbox (`- [ ]`), toggle it (`- [x]`)
    if string.match(line, "^(%s*)%-%s%[%s%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[%s%]%s", "%1- [x] ")))

      -- if line starts with an done checkbox (`- [x]`), remove it (``)
    elseif string.match(line, "^(%s*)%-%s%[x%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[x%]%s", "%1")))

      -- if line starts with a bullet (`- `), add an empty checkbox (`- [ ]`)
    elseif string.match(line, "^(%s*)%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1- [ ] ")))

      -- otherwise add a bullet
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
end

function M.markdownO()
  local current_line = vim.fn.getline "."
  local prefix = current_line:match "^%s*%-%s"
  local exact = current_line:match "^%s*%-%s$"
  if prefix and exact then
    local line = vim.fn.line "."
    vim.api.nvim_buf_set_lines(0, line - 1, line, true, {})
    vim.cmd "normal! o"
    vim.cmd "startinsert!"
  elseif prefix then
    vim.cmd("normal! o" .. prefix)
    vim.cmd "startinsert!"
  else
    vim.cmd "normal! o"
    vim.cmd "startinsert!"
  end
end

function M.markdownShiftO()
  local current_line = vim.fn.getline "."
  local prefix = current_line:match "^%s*%-%s"
  if prefix then
    vim.cmd("normal! O" .. prefix)
    vim.cmd "startinsert!"
  else
    vim.cmd "normal! O"
    vim.cmd "startinsert!"
  end
end

function M.markdownEnter()
  local current_line = vim.fn.getline "."
  local prefix = current_line:match "^%s*%-%s"
  local exact = current_line:match "^%s*%-%s$"
  if prefix and exact then
    local lineno = vim.fn.line "."
    vim.api.nvim_buf_set_lines(0, lineno - 1, lineno, true, { "" })
  elseif prefix then
    vim.api.nvim_put({ "", prefix }, "c", false, true)
  else
    vim.api.nvim_put({ "", "" }, "c", false, true)
  end
end

return M
