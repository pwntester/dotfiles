local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')
local api = vim.api

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
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[10])
    elseif mode == 'R' then
      -- Replace mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[12])
    elseif mode == 'v' or mode == 'V' or mode == '^V' then
      -- Visual mode
      vim.cmd('hi! DynamicMode guifg='..require'theme'.palette[16])
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
  sections.highlight('DynamicMode', function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return vim.fn.getcwd()..' '
  end),

  --- filename
  sections.highlight('Comment', function(window, buffer)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    if not vim.bo[buffer.bufnr].modified then
      return builtin.responsive_file(140, 90)(window, buffer):gsub(vim.fn.getcwd(), '')..' '
    end
  end),
  sections.highlight('ErrorMsg', function(window, buffer)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    if vim.bo[buffer.bufnr].modified then
      return builtin.responsive_file(140, 90)(window, buffer):gsub(vim.fn.getcwd(), '')..' '
    end
  end),

  --- file mod flag
  -- sections.highlight('ErrorMsg', function(_, buffer)
  --   if vim.bo[buffer.bufnr].modified then
  --     return '* '
  --   else
  --     return ''
  --   end
  -- end),

  --- git
  sections.highlight('Normal', subscribe.buf_autocmd(
    'el_git_branch',
    'BufEnter',
    function(window, buffer)
      if buffer.bufnr ~= api.nvim_get_current_buf() then return '' end
      return ' '..extensions.git_branch(window, buffer)..' '
    end
  )),

  --- col
  function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return '‣'
  end,
  sections.highlight('Comment', function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return builtin.column..' '
  end),

  --- percent
  function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return 'Ξ'
  end,
  sections.highlight('Comment', function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return builtin.percentage_through_file..' '
  end),

  --- filetype
  function(window)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return '␜'
  end,
  sections.highlight('Comment', function(window, buffer)
    if window.win_id ~= api.nvim_get_current_win() then return '' end
    return buffer.filetype..' '
  end),

  --- lsp
  sections.highlight('LspDiagnosticsError', subscribe.user_autocmd(
    'el_lsp_err_diagnostics',
    'LspDiagnosticsChanged',
    function(_, buffer)
      if buffer.bufnr ~= api.nvim_get_current_buf() then return '' end
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
      if buffer.bufnr ~= api.nvim_get_current_buf() then return '' end
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
