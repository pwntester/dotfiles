local api = vim.api

local function redrawModeColors(mode)

  local bg_color = util.getColorFromHighlight('Normal', 'bg')
  local blue = util.getColorFromHighlight('SpecialKey', 'fg')
  local green = util.getColorFromHighlight('Title', 'fg')
  local orange = util.getColorFromHighlight('Identifier', 'fg')
  local grey = util.getColorFromHighlight('PMenu', 'fg')
  local grey2 = util.getColorFromHighlight('Directory', 'fg')
  local yellow = util.getColorFromHighlight('Function', 'fg')

  -- Normal mode
  if mode == 'n' then
      vim.cmd("hi MyStatuslineFilename guifg="..yellow.." guibg="..bg_color)
  -- Insert mode
  elseif mode == 'i' then
      vim.cmd("hi MyStatuslineFilename guifg="..blue.." guibg="..bg_color)
  -- Replace mode
  elseif mode == 'R' then
      vim.cmd("hi MyStatuslineFilename guifg="..green.." guibg="..bg_color)
  -- Visual mode
  elseif mode == 'v' or mode == 'V' or mode == '^V' then
      vim.cmd("hi MyStatuslineFilename guifg="..orange.." guibg="..bg_color)
  -- Command mode
  elseif mode == 'c' then
      vim.cmd("hi MyStatuslineFilename guifg="..grey2.." guibg="..bg_color)
  -- Terminal mode
  elseif mode == 't' then
      vim.cmd("hi MyStatuslineFilename guifg="..grey.." guibg="..bg_color)
  end
  -- return empty string so as not to display anything in the statusline
  return ''
end

local function setFiletype(filetype)
  if filetype == '' then
    return '-'
  else
    return filetype
  end
end

local function git_branch()
  local branch = vim.fn['fugitive#head']()
  if '' == branch then return ''
  else return ' '..branch end
end

local function lspStatus()
  local sl = {}
  if vim.lsp.buf.server_ready() then
    table.insert(sl, [[%#MyStatuslineLSP#E:]])
    table.insert(sl, [[%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.util.buf_diagnostics_count('Error')")}]])
    table.insert(sl, [[%#MyStatuslineLSP# W:]])
    table.insert(sl, [[%#MyStatuslineLSPWarnings#%{luaeval("vim.lsp.util.buf_diagnostics_count('Warning')")}]])
  end
  return table.concat(sl)
end

local function path()
  local fname = vim.fn.expand('%')
  local width = vim.fn.winwidth(0) / 4
  if vim.fn.strlen(fname) > width then
    local segments = vim.fn.split(fname, '/')
    local reversed_segments = vim.fn.reverse(vim.fn.copy(segments))
    local truncated = ''
    for _, segment in ipairs(reversed_segments) do
      truncated  = '/' .. segment .. truncated
      if vim.fn.strlen(truncated) > width then
        break
      end
    end
    fname = '/'..segments[1]..'/...'..truncated
  end
  return fname
end

local function padding(ch)
  return (ch):rep(vim.fn.winwidth(0))
end

local function inactive()
  local l = '%#MyStatuslineBarNC#%{"'..padding('▁')..'"}'
  api.nvim_win_set_option(0, 'statusline', l)
end

local function active()

  local ft = api.nvim_buf_get_option(0, 'ft')

  if vim.tbl_contains(vim.g.special_buffers, ft) then
    local l
    if ft == 'dirvish' then
      l = '%#MyStatuslineFiletype#%{"'..path()..'"}'
      api.nvim_win_set_option(0, 'statusline', l)
    else
      l = '%#MyStatuslineBar#%{"'..padding('▃')..'"}'
      api.nvim_win_set_option(0, 'statusline', l)
    end
  else

    local statusline = {'%{"'..redrawModeColors(vim.fn.mode())..'"}'}

    -- " left side items
    --
    -- " filename
    -- " let filename = Filename()
    -- " if !empty(filename)
    -- "     let statusline.='%#MyStatuslineGit#%{Filename()}'
    -- " endif
    -- " let statusline.=' '

    -- right side items
    table.insert(statusline, '%=')

    -- cwd
    local cwd = vim.fn.getcwd()
    if cwd and '' ~= cwd then
      table.insert(statusline, '%#MyStatuslineFilename#%{getcwd()}')
      table.insert(statusline, ' ')
    end

    -- git
    local git_part = git_branch()
    table.insert(statusline, '%#MyStatuslineGit#%{"'..git_part..'"}')
    table.insert(statusline, ' ')

    -- column and current scroll percentage
    table.insert(statusline, '%#MyStatuslineLineCol#%c')
    table.insert(statusline, '/%#MyStatuslinePercentage#%p')
    table.insert(statusline, ' ')

    -- filetype
    local ft_part = setFiletype(ft)
    table.insert(statusline, '%#MyStatuslineGit#%{"'..ft_part..'"}')
    table.insert(statusline, ' ')

    -- LSP
    table.insert(statusline, '%#MyStatuslineLSP#'..lspStatus())
    table.insert(statusline, ' ')

    -- render statusline
    local l = table.concat(statusline)
    api.nvim_win_set_option(0, 'statusline', l)
  end


end

return {
  active = active;
  inactive = inactive;
}
