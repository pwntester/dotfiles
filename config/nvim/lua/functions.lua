local M = {}

function M.relpath(P, start)
  local split,min,append = vim.split, math.min, table.insert
  local compare = function(v) return v end
  local startl, Pl = split(start,'/'), split(P,'/')
  local n = min(#startl,#Pl)
  local k = n+1 -- default value if this loop doesn't bail out!
  for i = 1,n do
    if compare(startl[i]) ~= compare(Pl[i]) then
      k = i
      break
    end
  end
  local rell = {}
  for i = 1, #startl-k+1 do rell[i] = '..' end
  if k <= #Pl then
      for i = k,#Pl do append(rell,Pl[i]) end
  end
  return table.concat(rell,'/')
end

function M.onFileType()
  if vim.tbl_contains({'frecency', 'TelescopePrompt'}, vim.bo.filetype) or
     not vim.tbl_contains(special_buffers, vim.bo.filetype) then
    vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:Normal')
  else
    vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:NormalDark')
  end
end

function M.onEnter()

  if vim.tbl_contains(special_buffers, vim.bo.filetype) then
    vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:NormalDark')

    -- disable rainbow parentheses
    -- if vim.fn.exists':RainbowParentheses' then
    --   vim.cmd [[ RainbowParentheses! ]]
    -- end

    -- hide cursorline
    vim.wo.cursorline = false

    if not vim.tbl_contains({'octo', 'dashboard'}, vim.bo.filetype) then
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
  else
    vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:Normal')

    -- activate rainbow parentheses
    -- if vim.fn.exists':RainbowParentheses' then
    --   vim.cmd [[ RainbowParentheses ]]
    -- end

    -- show cursorline
    vim.wo.cursorline = true
  end
end

-- GOYO
function M.goyoEnter()
  local ids = vim.api.nvim_list_wins()
  for _, id in ipairs(ids) do
    if id ~= vim.api.nvim_get_current_win() then
      vim.api.nvim_win_set_option(id, 'winhighlight', 'NormalNC:Normal')
    end
  end
end

-- VEM-TABLINE
function M.deleteCurrentBuffer()
  local current_buffer = vim.api.nvim_get_current_buf()

  local next_buffer = vim.api.nvim_eval('g:vem_tabline#tabline.get_replacement_buffer()')
  pcall(vim.api.nvim_command, string.format('confirm %d bdelete', current_buffer))
  if next_buffer ~= 0 then
    pcall(vim.api.nvim_command, string.format('%d buffer', next_buffer))
  end
end

-- FZF/MARKDOWN/WIKI
function M.makeRelative(full, root)
  local cmd = string.format('realpath --relative-to=%s %s', root, full)
  local relative = vim.fn.trim(vim.fn.system(cmd))
  return vim.fn.substitute(relative, '\n+$', '', '')
end

-- WINDOW CLOSING
function M.closeWin()
  -- when closing a window, close all windows with special buffers pinned

  local current_winnr = vim.api.nvim_get_current_win()
  local current_ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(current_winnr), 'filetype')
  if vim.tbl_contains(special_buffers, current_ft) then
    -- closing a special buffer window, proceed
    return
  end

  local winids = vim.api.nvim_list_wins()
  if #winids > 1 then
    local regular_buffer_count = 0
    for _, w in ipairs(winids) do
      local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w), 'filetype')
      if not vim.tbl_contains(special_buffers, ft) then
        -- non-special buffer
        if vim.api.nvim_win_get_config(w)['relative'] == '' then
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
  local cmd = string.format('cnoreabbrev <expr> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))', from, from, to, from)
  if buffer then
    cmd = string.format('cnoreabbrev <expr><buffer> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))', from, from, to, from)
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
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)

    -- restore
    --v[1] = rhs
  end
end;

-- FUNCTIONS
function M.OpenURL()
  local uri = vim.fn.matchstr(vim.fn.getline("."), '[a-z]*:\\/\\/[^ >,;()]*')
  uri = vim.fn.shellescape(uri, 1)
  print(uri)
  if uri ~= "" then
    vim.fn.execute(string.format("!/Applications/Firefox.app/Contents/MacOS/firefox '%s'", uri))
    vim.cmd [[:redraw!]]
  else
    print("No URI found in line.")
  end
end

-- OCTO FUNCTIONS
function M.TODO()
  require'octo.utils'.get_issue('pwntester/bitacora', 41)
end

function M.Bitacora()
  require'octo.telescope.menu'.issues({repo='pwntester/bitacora', states="OPEN"})
end
function M.LabIssues()
  require'octo.telescope.menu'.issues({repo='github/pe-security-lab'})
end
function M.HubberReports()
  require'octo.telescope.menu'.issues({repo='github/pe-security-lab', labels ='Vulnerability report', states="OPEN"})
end
function M.VulnReports()
  require'octo.telescope.menu'.issues({repo='github/securitylab_vulnerabilities'})
end
function M.BountySubmissions()
  require'octo.telescope.menu'.issues({repo='github/securitylab-bounties', states="OPEN"})
end

return M
