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

-- ALIASES
util.alias('bd', "bp<bar>sp<bar>bn<bar>bd")
--util.alias('bd', "bp<bar>sp<bar>bn<bar>lua<space>util.deleteCurrentBuffer()")
util.alias('w1', 'w!')

