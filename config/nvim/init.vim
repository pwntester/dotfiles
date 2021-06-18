set hidden
set visualbell
set inccommand=nosplit
set updatetime=750
set noshowmode
set termguicolors
set sidescroll=5
set scrolloff=8
set linebreak
set ttimeoutlen=10
set timeoutlen=1000
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set nosmartindent
set nocindent
set noautoindent
set shiftround
set showtabline=2
set laststatus=2
set signcolumn=yes
set number relativenumber
set keywordprg=:help
set conceallevel=2
set concealcursor=nc
set wildoptions=pum
set pumblend=10
set wildignorecase
set noswapfile
set nobackup
set nowritebackup
silent !mkdir ~/.nvim/backups > /dev/null 2>&1
set undodir=~/.nvim/backups
set undofile
set ignorecase
set smartcase
set nojoinspaces

set jumpoptions=stack
set switchbuf=uselast

set shortmess=a     " abbreviate messages
set shortmess+=s    " no 'search hit BOTTOM'
set shortmess+=W    " don't give "written" or "[w]" when writing a file
set shortmess+=A    " don't give the "ATTENTION" message
set shortmess+=I    " don't give the intro message when starting :intro
set shortmess+=c    " don't give ins-completion-menu messages. eg: "match 1 of 2"
set shortmess+=o    " don't show "Press ENTER" when editing a file
set shortmess+=O    " don't show "Press ENTER" when editing a file
set shortmess+=t    " truncate file messages to fit on the command-line

set wildmode=longest
set wildmode+=full

set completeopt=menuone,noinsert,noselect

set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore=*.o,*.obj,*~                                                     
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg

" set complete=.
" set complete+=w
" set complete+=b
" set complete+=u
" set complete+=U
" set complete+=i
" set complete+=d
" set complete+=t

set shada='1000                  " previously edited files
set shada+=/1000                 " search history items
set shada+=:1000                 " command-line history items
set shada+=<1000                 " lines for each saved registry
set shada+=s100                  " max size of item in KiB
set shada+=h                     " no hlsearch when loading shada

set diffopt+=vertical            " Show vimdiff in vertical splits
set diffopt+=algorithm:patience  " Use git diffing algorithm
set diffopt+=context:1000000     " Don't fold

set formatoptions-=a             " Auto formatting is BAD.
set formatoptions-=t             " Don't auto format my code. I got linters for that.
set formatoptions+=c             " In general, I like it when comments respect textwidth
set formatoptions+=q             " Allow formatting comments w/ gq
set formatoptions-=o             " O and o, don't continue comments
set formatoptions+=r             " But do continue when pressing enter.
set formatoptions+=n             " Indent past the formatlistpat, not underneath it.
set formatoptions+=j             " Auto-remove comments if possible.
set formatoptions-=2             " I'm not in gradeschool anymore

set listchars=tab:>-
set listchars+=trail:.
set listchars+=extends:>
set listchars+=precedes:<
set listchars+=nbsp:%

" set fillchars=fold:⠀             " Unicode U+2800
" set fillchars+=foldopen:┌ 
" set fillchars+=foldclose:▸
" set fillchars+=foldsep:│

" FUNCTIONS
function! OpenURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;()]*')
  let s:uri = shellescape(s:uri, 1)
  echom s:uri
  if s:uri != ""
    silent exec "!/Applications/Firefox.app/Contents/MacOS/firefox '".s:uri."'"
    :redraw!
  else
    echo "No URI found in line."
  endif
endfunction

" AUTOCOMMANDS
augroup vimrc 
au! 

  " close additional wins
  " au QuitPre * lua util.closeWin() 

  " onEnter
  au TermEnter,WinEnter,BufEnter * nested lua util.onEnter() 

  au FileType * nested lua util.onFileType() 

  " check if buffer was changed outside of vim
  au FocusGained,BufEnter * checktime 

  " highlight yanked text
  au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500} 

  " terminal sane defaults
  au TermOpen * set ft=terminal 
  au TermOpen term://* startinsert 
  au TermLeave term://* stopinsert 
  au TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif 

  " help in vertical split
  au BufEnter *.txt if &buftype == 'help' | wincmd L | endif 

  " wiki
  " au BufWritePost ~/bitacora/* lua require'markdown'.asyncPush() 

  " list startify buffer
  autocmd FileType startify nested setlocal buflisted
augroup END 

" COMMANDS
command! LabIssues :call LabIssues()
command! HubberReports :call HubberReports()
command! VulnReports :call VulnReports()
command! BountySubmissions :call BountySubmissions()
command! Bitacora :call Bitacora()
command! TODO :call TODO()

function! TODO() abort
  lua require'octo.utils'.get_issue('pwntester/bitacora', 41)
endfunction

function! Bitacora() abort
  lua require'octo.telescope.menu'.issues({repo='pwntester/bitacora', states="OPEN"})
endfunction
function! LabIssues() abort
  lua require'octo.telescope.menu'.issues({repo='github/pe-security-lab'})
endfunction
function! HubberReports() abort
  lua require'octo.telescope.menu'.issues({repo='github/pe-security-lab', labels ='Vulnerability report', states="OPEN"})
endfunction
function! VulnReports() abort
  lua require'octo.telescope.menu'.issues({repo='github/securitylab_vulnerabilities'})
endfunction
function! BountySubmissions() abort
  lua require'octo.telescope.menu'.issues({repo='github/securitylab-bounties', states="OPEN"})
endfunction

" LUA INIT
lua require'init'

" MODULES
lua require'markdown'

" PLUGINS
lua require'plugins'

" MAPPINGS
lua require'mappings'

" ABBREVIATIONS
cnoreabbrev <expr> bd (getcmdtype() == ':' && getcmdline() =~ '^bd$')? 'lua require("bufdelete").bufdelete(0, true)' : 'bd'

" STARTIFY
" let g:startify_lists = [
"   \ { 'header': ['   GitHub Notifications'], 'type': function('octo#startify') },
"   \ { 'header': ['   MRU'],            'type': 'files' },
"   \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
"   \ { 'header': ['   Sessions'],       'type': 'sessions' },
"   \ { 'header': ['   Bookmarks'],      'type': 'bookmarks' },
"   \ { 'header': ['   Commands'],       'type': 'commands' },
"   \ ]
