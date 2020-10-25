local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')

local segments = {
  sections.split,

  --- set dynamic color based on current mode
  function(_, _)
    local mode = vim.fn.mode()
    if mode == 'n' then
      -- Normal mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[14])
    elseif mode == 'i' then
      -- Insert mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[9])
    elseif mode == 'R' then
      -- Replace mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[12])
    elseif mode == 'v' or mode == 'V' or mode == '^V' then
      -- Visual mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[10])
    elseif mode == 'c' then
      -- Command mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[6])
    elseif mode == 't' then
      -- Terminal mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[11])
    end
    return ''
  end,

  --- cwd
  sections.highlight('DynamicMode', function()
    return vim.fn.getcwd()..' '
  end),

  --- filename
  sections.highlight('Comment', function(window, buffer)
    return builtin.responsive_file(140, 90)(window,buffer):gsub(vim.fn.getcwd(), '')..' '
  end),

  --- file mod flag
  sections.highlight('Title', function()
    return builtin.modified_flag..' '
  end),

  --- git
  sections.highlight('Normal', subscribe.buf_autocmd(
    'el_git_branch',
    'BufEnter',
    function(window, buffer)
      return ' '..extensions.git_branch(window, buffer)..' '
    end
  )),

  --- col
  sections.highlight('Comment', function()
    return '‣'..builtin.column..' '
  end),

  --- percent
  sections.highlight('Comment', function()
    return 'Ξ'..builtin.percentage_through_file..' '
  end),

  --- filetype
  sections.highlight('Normal', function(_, buffer)
    return 'τ'..buffer.filetype..' '
  end),

  --- lsp
  sections.highlight('LspDiagnosticsError', subscribe.user_autocmd(
    'el_lsp_err_diagnostics',
    'LspDiagnosticsChanged',
    function(_, buffer)
      if not buffer.lsp then return '' end
      local count = vim.lsp.util.buf_diagnostics_count('Error')
      local icon = ''
      return string.format('%s %d ', icon, count)
    end
  )),
  sections.highlight('LspDiagnosticsWarning', subscribe.user_autocmd(
    'el_lsp_warn_diagnostics',
    'LspDiagnosticsChanged',
    function(_, buffer)
      if not buffer.lsp then return '' end
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
