
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
  'terminal',
  'TelescopePrompt',
  'packer'
}

util = require'functions'
statusline = require'statusline'

-- AUTOCOMMANDS
vim.cmd [[ augroup vimrc ]]
vim.cmd [[ au! ]]

-- debug
--vim.cmd [[ au BufEnter * nested echom 'entered '..expand('<afile>')  ]]
--vim.cmd [[ au BufLeave * nested echom 'leaving '..expand('<afile>')  ]]

-- close additional wins
vim.cmd [[ au QuitPre * lua util.closeWin() ]]

-- onEnter
vim.cmd [[ au TermEnter,WinEnter,BufEnter * nested lua util.onEnter() ]]

-- dim active win
vim.cmd [[ au FocusGained,VimEnter,WinEnter,TermEnter,BufEnter,BufNew * lua util.dimWin() ]]
vim.cmd [[ au FocusLost,WinLeave * lua util.undimWin() ]]

-- hide statusline on non-active windows
vim.cmd [[ au FocusGained,VimEnter,WinEnter,BufEnter * lua statusline.active() ]]
vim.cmd [[ au FocusLost,WinLeave,BufLeave * lua statusline.inactive() ]]

-- check if buffer was changed outside of vim
vim.cmd [[ au FocusGained,BufEnter * checktime ]]

-- highlight yanked text
vim.cmd [[ au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500} ]]

-- terminal sane defaults
vim.cmd [[ au TermOpen * set ft=terminal ]]
vim.cmd [[ au TermOpen term://* startinsert ]]
vim.cmd [[ au TermLeave term://* stopinsert ]]
vim.cmd [[ au TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif ]]

-- help in vertical split
vim.cmd [[ au BufEnter *.txt if &buftype == 'help' | wincmd L | endif ]]

-- wiki
vim.cmd [[ au BufWritePost ~/bitacora/* lua require'markdown'.asyncPush() ]]

vim.cmd [[ augroup END ]]

-- ALIASES
util.alias('bd', "bp<bar>sp<bar>bn<bar>bd")
--util.alias('bd', "bp<bar>sp<bar>bn<bar>lua<space>util.deleteCurrentBuffer()")
util.alias('w1', 'w!')

-- MODULES
require'markdown'

-- PLUGINS
require'plugins'

-- MAPPINGS
require'mappings'
