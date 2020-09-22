local api = vim.api
local match = string.match
local format = string.format
local loop = vim.loop

local function pasteLink()
  -- TODO: get url from clipboard
  local url = 'foo'
  local link = format('[](%s)', url)
      local line = vim.fn.getline('.')
  vim.fn.setline('.', vim.fn.strpart(line, 0, vim.fn.col('.') - 1) .. link .. vim.fn.strpart(line, vim.fn.col('.') - 1))
  -- TODO: move cursor to [_]()
end

local function pasteImage(dir)
  local stdout = loop.new_pipe(false)
  local stderr = loop.new_pipe(false)
  local handle = nil

  local function on_read(err, _)
    if err then
      print('ERROR: ', err)
    end
  end

  local uuid = vim.fn.trim(vim.fn.system('uuidgen'))
  uuid = string.gsub(uuid, '\n+$', '')
  dir = format('%s/%s', vim.fn.expand('%:p:h'), dir)
  if vim.fn.isdirectory(dir) then
    print(dir)
    vim.fn.mkdir(dir, 'p')
  end
  local cmd = format('pngpaste %s/%s.png', dir, uuid)

  handle = loop.spawn('sh', {
      args = {'-c', cmd};
      stdio = {stdout,stderr};
    },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      if not handle:is_closing() then
        handle:close()
      end
      local img = format('%s/%s.png', dir, uuid)
      local link = format('![](%s)', img)
      local line = vim.fn.getline('.')
      vim.fn.setline('.', vim.fn.strpart(line, 0, vim.fn.col('.') - 1) .. link .. vim.fn.strpart(line, vim.fn.col('.') - 1))
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
      print('ERROR: ', err)
    end
  end

  local cmd_str = 'git add %s ;git commit -m "Auto commit of %s" "%s";git push;'
  local cmd = format(cmd_str, vim.fn.expand('%'), vim.fn.expand('%:t'), vim.fn.expand('%'))

  print('AutoCommiting changes ...')
  handle = loop.spawn('sh', {
      args = {'-c', cmd};
      stdio = {stdout,stderr};
    },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      if not handle:is_closing() then
        handle:close()
      end
      print('Saved!')
    end)
  )
  loop.read_start(stdout, on_read)
  loop.read_start(stderr, on_read)
end

local function markdownBlocks()
  vim.cmd [[ sign define codeblock linehl=markdownCode ]]
  local continue = false
  api.nvim_command('sign unplace * file='..vim.fn.expand('%'))

  -- iterate through each line in the buffer
  for lnum = 1, #vim.fn.getline(1, '$'), 1 do
    -- detect the start fo a code block
    local line = vim.fn.getline(lnum)
    if ((not continue and match(line, '^```.*$')) or (not match(line, '^```.*$') and continue)) then
      -- continue placing signs, until the block stops
      continue = true
      -- place sign
      api.nvim_command('sign place '..lnum..' line='..lnum..' name=codeblock file='..vim.fn.expand('%'))
    elseif line == "```" and continue then
      -- place sign
      api.nvim_command('sign place '..lnum..' line='..lnum..' name=codeblock file='..vim.fn.expand('%'))
      -- stop placing signs
      continue = false
    end
  end
end

local function setup()
  vim.cmd [[ augroup markdown]]
  vim.cmd [[ autocmd! ]]
  vim.cmd [[ au InsertLeave *.md  lua require'markdown'.markdownBlocks() ]]
  vim.cmd [[ au BufEnter *.md     lua require'markdown'.markdownBlocks() ]]
  vim.cmd [[ au BufWritePost *.md lua require'markdown'.markdownBlocks() ]]
  vim.cmd [[ au CursorMoved *.md  lua require'markdown'.markdownBlocks() ]]
  vim.cmd [[ au FileType markdown nested if exists('g:mkdx#settings') | let b:pear_tree_map_special_keys = 0 | endif ]]
  vim.cmd [[ au FileType markdown nested setlocal conceallevel=2 ]]
  vim.cmd [[ au FileType markdown nested setlocal concealcursor=c ]]
  vim.cmd [[ au FileType markdown nested setlocal signcolumn=no ]]
  vim.cmd [[ au FileType markdown nested setlocal spell complete+=kspell ]]
  vim.cmd [[ au BufWritePost ~/bitacora/* lua require'markdown'.asyncPush() ]]
  vim.cmd [[ au FileType markdown nnoremap <leader>p lua require'markdown'.pasteImage('images')<CR> ]]
  vim.cmd [[ au FileType markdown nnoremap <leader>l lua require'markdown'.pasteLink()<CR> ]]
  vim.cmd [[ augroup END ]]
end

return {
  setup = setup;
  markdownBlocks = markdownBlocks;
  asyncPush = asyncPush;
  pasteImage = pasteImage;
  pasteLink = pasteLink;
}