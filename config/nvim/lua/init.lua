-- GLOBALS
_G.util = require'functions'
_G.RELOAD = function(module)
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
  'packer',
  'NvimTree',
  'octo_panel'
}

-- packer.nvim
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- -- OPTIONS
-- require('globals')
-- local opt = vim.opt
--
-- opt.belloff        = 'all' -- Just turn the dang bell off
-- opt.inccommand     = 'nosplit'
-- opt.breakindent    = true
-- opt.showbreak      = string.rep(' ', 3) -- Make it so that long lines wrap smartly
-- opt.linebreak      = true
--
-- opt.shiftwidth     = 2
-- opt.tabstop        = 2
-- opt.softtabstop    = 2
-- opt.expandtab      = true
--
-- opt.relativenumber = true  -- Show line numbers
-- opt.number         = true  -- But show the actual number for the line we're on
-- opt.ignorecase     = true  -- Ignore case when searching...
-- opt.smartcase      = true  -- ... unless there is a capital letter in the query
-- opt.hidden         = true  -- I like having buffers stay around
-- opt.cursorline     = true  -- Highlight the current line
-- opt.equalalways    = false -- I don't like my windows changing all the time
-- opt.splitbelow     = true  -- Prefer windows splitting to the bottom
-- opt.updatetime     = 750   -- Make updates happen faster
-- opt.scrolloff      = 10    -- Make it so there are always ten lines below my cursor
-- opt.keywordprg     = ':help'
-- opt.conceallevel   = 2
-- opt.showtabline    = 2
-- opt.laststatus     = 2
-- opt.signcolumn     = 'yes'
-- opt.concealcursor  = 'nc'
-- opt.wildoptions    = 'pum'
-- opt.pumblend       = 17
-- opt.wildignorecase = true
-- opt.swapfile       = false
-- opt.backup         = false
-- opt.writebackup    = false
-- opt.joinspaces     = false
--
-- opt.jumpoptions    = 'stack'
--
-- -- opt.shortmess      = opt.shortmess
-- --                      + 'a'    -- abbreviate messages
-- --                      + 's'    -- no 'search hit BOTTOM'
-- --                      + 'W'    -- don't give "written" or "[w]" when writing a file
-- --                      + 'A'    -- don't give the "ATTENTION" message
-- --                      + 'I'    -- don't give the intro message when starting :intro
-- --                      + 'c'    -- don't give ins-completion-menu messages. eg: "match 1 of 2"
-- --                      + 'o'    -- don't show "Press ENTER" when editing a file
-- --                      + 'O'    -- don't show "Press ENTER" when editing a file
-- --                      + 't'    -- truncate file messages to fit on the command-line
--
-- opt.wildmode = {'longest', 'list', 'full'}
-- opt.wildmode = opt.wildmode - 'list'
-- opt.wildmode = opt.wildmode + { 'longest', 'full' }
--
-- opt.wildignore     = opt.wildignore
--                      + {'*.swp','*.pyc','*.bak','*.class','*.orig'}
--                      + {'.git', '.hg', '.bzr', '.svn'}
--                      + {'build/*', 'tmp/*', 'vendor/cache/*', 'bin/*'}
--                      + {'*.o', '*.obj', '*~'}
--                      + {'*DS_Store*'}
--                      + {'log/**'}
--                      + {'tmp/**'}
--                      + {'*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg', '*.svg'}
--
-- opt.complete       = opt.complete
--                      + '.'
--                      + 'w'
--                      + 'b'
--                      + 'u'
--                      + 'U'
--                      + 'i'
--                      + 'd'
--                      + 't'
--
-- opt.completeopt    = {'menu', 'menuone', 'noselect'}
--
-- opt.shada          = opt.shada
--                      + "'1000" -- previously edited files
--                      + '/1000' -- search history items
--                      + ':1000' -- command-line history items
--                      + '<1000' -- lines for each saved registry
--                      + 's100'  -- max size of item in KiB
--                      + 'h'     -- no hlsearch when loading shada
--
-- opt.diffopt        = opt.diffopt
--                     + 'vertical'           -- Show vimdiff in vertical splits
--                     + 'algorithm:patience' -- Use git diffing algorithm
--                     + 'context:1000000'    -- Don't fold
--
-- opt.formatoptions = opt.formatoptions
--                     - 'a'     -- Auto formatting is BAD.
--                     - 't'     -- Don't auto format my code. I got linters for that.
--                     + 'c'     -- In general, I like it when comments respect textwidth
--                     + 'q'     -- Allow formatting comments w/ gq
--                     - 'o'     -- O and o, don't continue comments
--                     + 'r'     -- But do continue when pressing enter.
--                     + 'n'     -- Indent past the formatlistpat, not underneath it.
--                     + 'j'     -- Auto-remove comments if possible.
--                     - '2'     -- I'm not in gradeschool anymore
--
-- opt.listchars     = {
--                       tab       = '>-';
--                       trail     = '.';
--                       extends   = '>';
--                       precedes  = '<';
--                       nbsp      = '%';
--                     }
--
-- opt.fillchars     = {
--                       eob       = "~",
--                       fold      = '⠀', -- Unicode U+2800
--                       foldopen  = '+',
--                       foldclose = '-'
--                     }


--silent !mkdir ~/.nvim/backups > /dev/null 2>&1
--opt.undodir        =~/.nvim/backups
--opt.undofile
--opt.termguicolors  = true
--opt.sidescroll=5
--opt.ttimeoutlen=10
--opt.timeoutlen=1000
--opt.smartindent
--opt.shiftround

-- ALIASES
--util.alias('bd', "bp<bar>sp<bar>bn<bar>lua<space>util.deleteCurrentBuffer()")
--util.alias('bd', "bp<bar>sp<bar>bn<bar>bd")
--util.alias('bd', "Sayonara!<CR>")
--util.alias('w1', 'w!')

