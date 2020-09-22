local vim = vim

-- GLOBALS
RELOAD = function(module)
  package.loaded[module] = nil
  return require(module)
end

vim.g.special_buffers = {
  'help',
  'fortifytestpane',
  'fortifyauditpane',
  'defx',
  'dirvish',
  'qf',
  'vim-plug',
  'fzf',
  'magit',
  'goterm',
  'vista_kind',
  'codeqlpanel',
  'goyo_pad',
  'terminal'
}

statusline = require'statusline'
util = require'functions'

-- AUTOCOMMANDS
vim.cmd [[ augroup vimrc ]]
  vim.cmd [[ autocmd! ]]

  -- close additional wins
  vim.cmd [[ autocmd QuitPre * lua util.closeWin() ]]

  -- dont show column
  vim.cmd [[ autocmd BufEnter *.* :set colorcolumn=0 ]]

  -- dim active win
  vim.cmd [[ autocmd FocusGained,VimEnter,WinEnter,TermEnter,BufEnter,BufNew * lua util.dimWin() ]]
  vim.cmd [[ autocmd FocusLost,WinLeave * lua util.undimWin() ]]

  -- hide statusline on non-active windows
  vim.cmd [[ autocmd FocusGained,VimEnter,WinEnter,BufEnter * lua statusline.active() ]]
  vim.cmd [[ autocmd FocusLost,WinLeave,BufLeave * lua statusline.inactive() ]]

  -- check if buffer was changed outside of vim
  vim.cmd [[ autocmd FocusGained,BufEnter * checktime ]]

  -- mark qf as not listed
  vim.cmd [[ autocmd FileType qf setlocal nobuflisted ]]

  -- force write shada on leaving nvim
  vim.cmd [[ autocmd VimLeave * wshada! ]]

  -- highlight yanked text
  vim.cmd [[ au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500} ]]

  -- pin buffers
  vim.cmd [[ au WinEnter,BufEnter *  nested lua util.pinBuffer() ]]
  vim.cmd [[ au WinEnter,BufEnter {} nested lua util.pinBuffer() ]]

  -- BufEnter is not triggered for dirvish buffer
  vim.cmd [[ au FileType dirvish lua util.pinBuffer() ]]

  -- terminal sane defaults
  vim.cmd [[ au TermOpen * set ft=terminal ]]
  vim.cmd [[ au TermEnter * lua util.pinBuffer() ]]
  vim.cmd [[ au TermOpen term://* startinsert ]]
  vim.cmd [[ au TermLeave term://* stopinsert ]]

  -- ignore various filetypes as those will close terminal automatically
  -- ignore fzf
  vim.cmd [[ autocmd TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif ]]

vim.cmd [[ augroup END ]]

-- ALIASES
util.alias('bd', "bp<bar>sp<bar>bn<bar>lua<space>util.deleteCurrentBuffer()")
util.alias('w1', 'w!')

-- COMMANDS
-- vim.cmd [[ command! -nargs=0 -bang Q quitall!<bang> ]]

-- MODULES
require'markdown'.setup()

-- PLUGINS
require'plugins'.setup()

-- MAPPINGS
require'mappings'.setup()

-- THEME
require'theme'.setup()
