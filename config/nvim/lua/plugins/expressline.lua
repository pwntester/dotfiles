local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')
--local relpath = require('pl.path').relpath
local format = string.format

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
    local bg = require'theme'.palette[2]
    if mode == 'n' then
      -- StatuslineColor2 mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[11], bg))
    elseif mode == 'i' then
      -- Insert mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[14], bg))
    elseif mode == 'R' then
      -- Replace mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[12], bg))
    elseif mode == 'v' or mode == 'V' or mode == '^V' then
      -- Visual mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[9], bg))
    elseif mode == 'c' then
      -- Command mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[6], bg))
    elseif mode == 't' then
      -- Terminal mode
      vim.cmd(format('hi! StatuslineDynamicMode guifg=%s guibg=%s', require'theme'.palette[11], bg))
    end
    vim.cmd(format('hi! StatuslineColor1 guifg=%s guibg=%s', require'theme'.palette[4], bg))
    vim.cmd(format('hi! StatuslineColor2 guifg=%s guibg=%s', require'theme'.palette[6], bg))
    vim.cmd(format('hi! StatuslineColor3 guifg=%s guibg=%s', require'theme'.palette[9], bg))
    vim.cmd(format('hi! StatuslineColor4 guifg=%s guibg=%s', require'theme'.palette[1], require'theme'.palette[11]))
    vim.cmd(format('hi! StatuslineLspError guifg=%s guibg=%s', require'theme'.palette[9], bg))
    vim.cmd(format('hi! StatuslineLspWarning guifg=%s guibg=%s', require'theme'.palette[10], bg))
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
  sections.highlight('StatuslineColor2', subscribe.buf_autocmd(
    'el_git_branch',
    'BufEnter',
    function(window, buffer)
      if window and buffer then
        local branch = extensions.git_branch(window, buffer)
        if not should_print('git_branch', window, buffer) then return '' end
        return ' '..extensions.git_branch(window, buffer)..' '
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
      local count = vim.lsp.util.buf_diagnostics_count('Error')
      local icon = ''
      return string.format('%s %d ', icon, count)
    end
  )),
  sections.highlight('StatuslineLspWarning', subscribe.user_autocmd(
    'el_lsp_warn_diagnostics',
    'LspDiagnosticsChanged',
    function(window, buffer)
      if not should_print('lsp', window, buffer) then return '' end
      local count = vim.lsp.util.buf_diagnostics_count('Warning')
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
