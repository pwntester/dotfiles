local vim = vim
local api = vim.api
local format = string.format

local M = {}

-- RAINBOW-PARENTHESES
function M.onEnter()

  if not vim.tbl_contains(vim.g.special_buffers, vim.bo.filetype) then

    -- activate rainbow parentheses
    api.nvim_command('RainbowParentheses')

    -- show cursorline
    vim.wo.cursorline = true

  elseif vim.fn.exists(':RainbowParentheses') then

    -- deactivate rainbow parentheses
    api.nvim_command('RainbowParentheses!')

    -- hide cursorline
    vim.wo.cursorline = false

    -- prevent changing buffer
    vim.cmd [[ nnoremap <silent><buffer><s-l> <nop> ]]
    vim.cmd [[ nnoremap <silent><buffer><s-h> <nop> ]]
    vim.cmd [[ nnoremap <silent><buffer><leader>m <nop> ]]
    vim.cmd [[ nnoremap <silent><buffer><leader>f <nop> ]]
    vim.cmd [[ cmap <silent><buffer><expr>e<Space> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "e<Space>") ]]
    vim.cmd [[ cmap <silent><buffer><expr>bd<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bd<Return>") ]]
    vim.cmd [[ cmap <silent><buffer><expr>bp<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bp<Return>") ]]
    vim.cmd [[ cmap <silent><buffer><expr>bn<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bn<Return>") ]]
  end
end

-- GOYO
function M.goyoEnter()
  local ids = api.nvim_list_wins()
  for _, id in ipairs(ids) do
    if id ~= api.nvim_get_current_win() then
      api.nvim_win_set_option(id, 'winhighlight', 'NormalNC:Normal')
    end
  end
end

-- VEM-TABLINE
-- function M.deleteCurrentBuffer()
--   local current_buffer = api.nvim_get_current_buf()
--
--   local next_buffer = api.nvim_eval('g:vem_tabline#tabline.get_replacement_buffer()')
--   pcall(api.nvim_command, format('confirm %d bdelete', current_buffer))
--   if next_buffer ~= 0 then
--     pcall(api.nvim_command, format('%d buffer', next_buffer))
--   end
-- end

-- FZF/MARKDOWN/WIKI
function M.makeRelative(lines)
  local root = vim.fn.expand('%:p:h')
  local cmd = format('realpath --relative-to=%s %s', root, lines[1])
  local relative = vim.fn.trim(vim.fn.system(cmd))
  return vim.fn.substitute(relative, '\n+$', '', '')
end

-- WINDOW DIMMING
function M.dimWin()
  api.nvim_win_set_option(0, 'winhighlight', 'EndOfBuffer:EndOfBuffer,SignColumn:Normal,LineNr:LineNr,CursorLineNr:CursorLineNr')
end

function M.undimWin()
  api.nvim_win_set_option(0, 'winhighlight', 'EndOfBuffer:EndOfBufferNC,SignColumn:NormalNC,LineNr:LineNrNC,CursorLineNr:CursorLineNrNC')
end

-- STATUSLINE
function M.getColorFromHighlight(hl, element)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl)), element..'#')
end

-- WINDOW CLOSING
function M.closeWin()
  -- when closing a window, close all windows with special buffers pinned

  local current_winnr = api.nvim_get_current_win()
  local current_ft = api.nvim_buf_get_option(api.nvim_win_get_buf(current_winnr), 'filetype')
  if vim.tbl_contains(vim.g.special_buffers, current_ft) then
    -- closing a special buffer window, proceed
    return
  end

  local winids = api.nvim_list_wins()
  if #winids > 1 then
    local regular_buffer_count = 0
    for _, w in ipairs(winids) do
      local ft = api.nvim_buf_get_option(api.nvim_win_get_buf(w), 'filetype')
      if not vim.tbl_contains(vim.g.special_buffers, ft) then
        -- non-special buffer
        if api.nvim_win_get_config(w)['relative'] == '' then
          -- non-floating window
          regular_buffer_count = regular_buffer_count + 1
        end
      end
    end

    if regular_buffer_count == 1 then
      -- at this point we know there are multiple window, but only the
      -- current one is showing a non-special buffer. close them all
      vim.cmd'quitall'
    end
  end
end

-- ALIASES
function M.alias(from, to, buffer)
  local cmd = format('cnoreabbrev <expr> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))', from, from, to, from)
  if buffer then
    cmd = format('cnoreabbrev <expr><buffer> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))', from, from, to, from)
  end
  vim.cmd(cmd)
end

-- MAPPINGS
function M.map(mappings, defaults)
  for k, v in pairs(mappings) do
    local opts = vim.fn.deepcopy(defaults)
    local mode = k:sub(1,1)
    if mode == '_' then mode = '' end
    local lhs = k:sub(2)
    local rhs = v[1]
    v[1] = nil

    -- merge default options and individual ones
    for i,j in pairs(v) do opts[i] = j end

    -- for <expr> mappings, discard all options except `noremap`
    -- probably needed for <script> or other modifiers that need to be first
    if opts.expr then
      local noremap_opt = opts['noremap']
      opts = { expr = true; noremap = noremap_opt }
    end

    -- apply settings
    api.nvim_set_keymap(mode, lhs, rhs, opts)

    -- restore
    --v[1] = rhs
  end
end;

return M
