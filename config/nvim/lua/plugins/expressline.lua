local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')
local format = string.format
--local c = require('colorbuddy.color').colors

local function should_print(module, window, buffer)
  if window and window.win_id ~= vim.api.nvim_get_current_win() then
    return false
  elseif buffer and buffer.bufnr ~= vim.api.nvim_get_current_buf() then
    return false
  elseif buffer and vim.tbl_contains(vim.g.special_buffers, buffer.filetype) then
    return false
  elseif module == 'lsp' and buffer and not buffer.lsp then
    return false
  end
  return true
end

local segments = {

  --- set dynamic color based on current mode
  function(_, _)
    local mode = vim.fn.mode()
    local base00 = tostring(require'nautilus'.Normal.bg)
    local base01 = tostring(require'nautilus'.CursorLine.bg)
    local base03 = tostring(require'nautilus'.NonText.fg)
    local base04 = tostring(require'nautilus'.Search.bg)
    local base05 = tostring(require'nautilus'.Normal.fg)
    local base08 = tostring(require'nautilus'.ErrorMsg.fg)
    local base09 = tostring(require'nautilus'.Constant.fg)
    local base0A = tostring(require'nautilus'.Identifier.fg)
    local base0B = tostring(require'nautilus'.String.fg)
    local base0C = tostring(require'nautilus'.Special.fg)
    if mode == 'n' then
      -- Normal mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base0A, base01))
    elseif mode == 'i' then
      -- Insert mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base0C, base01))
    elseif mode == 'R' then
      -- Replace mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base0B, base01))
    elseif mode == 'v' or mode == 'V' or mode == '^V' then
      -- Visual mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base08, base01))
    elseif mode == 'c' then
      -- Command mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base05, base01))
    elseif mode == 't' then
      -- Terminal mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', base0A, base01))
    end
    vim.cmd(format('hi! StatuslineColor1 guifg=%s guibg=%s', base03, base01))
    vim.cmd(format('hi! StatuslineColor2 guifg=%s guibg=%s', base05, base01))
    vim.cmd(format('hi! StatuslineColor3 guifg=%s guibg=%s', base04, base01))
    vim.cmd(format('hi! StatuslineColor4 guifg=%s guibg=%s', base00, base0A))
    vim.cmd(format('hi! StatuslineLspError guifg=%s guibg=%s', base08, base01))
    vim.cmd(format('hi! StatuslineLspWarning guifg=%s guibg=%s', base09, base01))
    return ''
  end,

  -- LEFT
  --- mode
  sections.highlight('StatuslineColor4', function(window, buffer)
    if not should_print('cwd', window, buffer) then return '' end
    return string.format(' %s ', require('el.data').modes[vim.api.nvim_get_mode().mode][1])
  end),

  -- RIGHT
  sections.split,

  --- cwd
  sections.highlight('StatuslineDynamicMode', function(window, buffer)
    if not should_print('cwd', window, buffer) then return '' end
    return vim.fn.getcwd()..' '
  end),

  --- filename
  sections.highlight('StatuslineDynamicMode', function(window, buffer)
    if not should_print('filename', window, buffer) then return '' end
    local name = builtin.responsive_file(140, 90)(window, buffer)
    --local relname = util.makeRelative(name, vim.fn.getcwd())
    local relname = util.relpath(name, vim.fn.getcwd())
    return relname..' '
  end),

  --- file mod flag
  sections.highlight('StatuslineColor3', function(window, buffer)
    if not should_print('filemod', window, buffer) then return '' end
    if vim.bo[buffer.bufnr].modified then return '* '
    else return '' end
  end),

  --- git
  sections.highlight('StatuslineColor1', subscribe.buf_autocmd(
    'el_git_hunks',
    'BufEnter',
    function(_, buffer)
      if buffer and vim.b.gitsigns_status then
        if not should_print('git_hunks', _, buffer) then return '' end
        return vim.b.gitsigns_status..' '
      end
    end
  )),
  sections.highlight('StatuslineColor2', subscribe.buf_autocmd(
    'el_git_branch',
    'BufEnter',
    function(_, buffer)
      if buffer and extensions.git_branch(_, buffer) then
        if not should_print('git_branch', _, buffer) then return '' end
        return ' '..extensions.git_branch(_, buffer)..' '
      end
    end
  )),

  --- col
  function(window, buffer)
    if not should_print('col_icon', window, buffer) then return '' end
    return '‣'
  end,
  sections.highlight('StatuslineColor1', function(window, buffer)
    if not should_print('col', window, buffer) then return '' end
    return builtin.column..' '
  end),

  --- percent
  function(window, buffer)
    if not should_print('percent_icon', window, buffer) then return '' end
    return 'Ξ'
  end,
  sections.highlight('StatuslineColor1', function(window, buffer)
    if not should_print('percent', window, buffer) then return '' end
    return builtin.percentage_through_file..' '
  end),

  --- filetype
  function(window, buffer)
    if not should_print('filetype_icon', window, buffer) then return '' end
    if buffer.name ~= '' then
      local icon = require'nvim-web-devicons'.get_icon(buffer.name, buffer.filetype, { default = true })
      return icon..' '
    else
      return '␜'
    end
  end,
  sections.highlight('StatuslineColor1', function(window, buffer)
    if not should_print('filetype', window, buffer) then return '' end
    return buffer.filetype..' '
  end),

  --- lsp
  sections.highlight('StatuslineLspError', subscribe.user_autocmd(
    'el_lsp_err_diagnostics',
    'LspDiagnosticsChanged',
    function(window, buffer)
      if not should_print('lsp', window, buffer) then return '' end
      local count = vim.lsp.diagnostic.get_count(buffer.bufnr, 'Error')
      local icon = ''
      return string.format('%s %d ', icon, count)
    end
  )),
  sections.highlight('StatuslineLspWarning', subscribe.user_autocmd(
    'el_lsp_warn_diagnostics',
    'LspDiagnosticsChanged',
    function(window, buffer)
      if not should_print('lsp', window, buffer) then return '' end
      local count = vim.lsp.diagnostic.get_count(buffer.bufnr, 'Warning')
      local icon = ''
      return string.format('%s %d ', icon, count)
    end
  )),
}

require('el').setup {
  generator = function(_)
    return segments
  end;
}
