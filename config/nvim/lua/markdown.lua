local api = vim.api
local match = string.match
local format = string.format
local loop = vim.loop

-- TODO
-- vim.cmd [[
-- inoremap <expr> <c-x><c-f> fzf#vim#complete(fzf#wrap({'source': 'find '.getcwd().' -type f -name "*.md" -not -path "*/\.*"\; \| xargs realpath', 'reducer': function('<sid>make_relative') }))
-- ]]

vim.cmd [[command! -range ToggleBullets lua require'markdown'.toggleBullets()]]

local function pasteLink()
  -- TODO: get url from clipboard
  local url = "foo"
  local link = format("[](%s)", url)
  local line = vim.fn.getline "."
  vim.fn.setline(".", vim.fn.strpart(line, 0, vim.fn.col "." - 1) .. link .. vim.fn.strpart(line, vim.fn.col "." - 1))
  -- TODO: move cursor to [_]()
end

local function pasteImage(dir)
  local stdout = loop.new_pipe(false)
  local stderr = loop.new_pipe(false)
  local handle = nil

  local function on_read(err, _)
    if err then
      print("ERROR: ", err)
    end
  end

  local uuid = vim.fn.trim(vim.fn.system "uuidgen")
  uuid = string.gsub(uuid, "\n+$", "")
  dir = format("%s/%s", vim.fn.expand "%:p:h", dir)
  if vim.fn.isdirectory(dir) then
    print(dir)
    vim.fn.mkdir(dir, "p")
  end
  local cmd = format("pngpaste %s/%s.png", dir, uuid)

  handle = loop.spawn(
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
      local img = format("%s/%s.png", dir, uuid)
      local link = format("![](%s)", img)
      local line = vim.fn.getline "."
      vim.fn.setline(
        ".",
        vim.fn.strpart(line, 0, vim.fn.col "." - 1) .. link .. vim.fn.strpart(line, vim.fn.col "." - 1)
      )
    end)
  )
  loop.read_start(stdout, on_read)
  loop.read_start(stderr, on_read)
end

local function asyncPush()
  local stdout = loop.new_pipe(false)
  local stderr = loop.new_pipe(false)
  local handle = nil

  local function on_read(err, _)
    if err then
      print("ERROR: ", err)
    end
  end

  local cmd_str = 'git add %s ;git commit -m "Auto commit of %s" "%s";git push;'
  local cmd = format(cmd_str, vim.fn.expand "%", vim.fn.expand "%:t", vim.fn.expand "%")

  --print('AutoCommiting changes ...')
  handle = loop.spawn(
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
  loop.read_start(stdout, on_read)
  loop.read_start(stderr, on_read)
end

local function markdownBlocks()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  pcall(api.nvim_command, "sign unplace * file=" .. vim.fn.expand "%")

  local continue = false
  -- iterate through each line in the buffer
  for lnum = 1, #vim.fn.getline(1, "$"), 1 do
    -- detect the start fo a code block
    local line = vim.fn.getline(lnum)
    if (not continue and match(line, "^%s*```.*$")) or (not match(line, "^%s*```.*$") and continue) then
      -- continue placing signs, until the block stops
      continue = true
      -- place sign
      api.nvim_command("sign place " .. lnum .. " line=" .. lnum .. " name=codeblock file=" .. vim.fn.expand "%")
    elseif match(line, "^%s*```%s*") and continue then
      -- place sign
      api.nvim_command("sign place " .. lnum .. " line=" .. lnum .. " name=codeblock file=" .. vim.fn.expand "%")
      -- stop placing signs
      continue = false
    end
  end
end

-- add/remove list bullets
local function toggleBullets()
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
local function toggleCheckboxes()
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

-- continue lists when adding a new line
_G.markdownEnter = function()
  local current_line = vim.fn.getline "."
  local prefix = current_line:match "^%s*%-%s"
  if prefix then
    return "\n" .. prefix
  else
    return "\n"
  end
end

_G.markdownO = function()
  local current_line = vim.fn.getline "."
  local prefix = current_line:match "^%s*%-%s"
  if prefix then
    vim.cmd("normal! o" .. prefix)
    vim.cmd "startinsert!"
  else
    vim.cmd "normal! o"
    vim.cmd "startinsert!"
  end
end

_G.markdownShiftO = function()
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

return {
  markdownBlocks = markdownBlocks,
  asyncPush = asyncPush,
  pasteImage = pasteImage,
  pasteLink = pasteLink,
  toggleCheckboxes = toggleCheckboxes,
  toggleBullets = toggleBullets,
  continueList = continueList,
}
