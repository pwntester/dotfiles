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
set smartindent
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

set shortmess=a     " abbreviate messages
set shortmess+=s    " no 'search hit BOTTOM'
set shortmess+=W    " don't give "written" or "[w]" when writing a file
set shortmess+=A    " don't give the "ATTENTION" message
set shortmess+=I    " don't give the intro message when starting :intro
set shortmess+=c    " don't give ins-completion-menu messages. eg: "match 1 of 2"
set shortmess+=o    " don't show "Press ENTER" when editing a file
set shortmess+=O    " don't show "Press ENTER" when editing a file

set wildmode=longest
set wildmode+=full

set completeopt=menu
set completeopt+=menuone
set completeopt+=noselect                               

set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore=*.o,*.obj,*~                                                     
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg

set complete=.
set complete+=w
set complete+=b
set complete+=u
set complete+=U
set complete+=i
set complete+=d
set complete+=t

set shada=!,%,'1000,<1000,s100,h

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

set fillchars=fold:⠀             " Unicode U+2800
set fillchars+=foldopen:+
set fillchars+=foldclose:-

" FUNCTIONS
function! OpenURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;()]*')
  let s:uri = shellescape(s:uri, 1)
  echom s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
    :redraw!
  else
    echo "No URI found in line."
  endif
endfunction

function ToggleDirvish(arg) abort
  for w in nvim_list_wins()
    let bufnr = nvim_win_get_buf(w)
    if nvim_buf_get_option(bufnr, 'filetype') == 'dirvish'
      call nvim_win_close(w, 1)
      return
    endif
  endfor
  let l:arg = a:arg
  if l:arg == '%' | let l:arg = getreg('%') | endif
  leftabove 30 vsplit
  execute 'Dirvish '.l:arg
endfunction

function! s:setup_git_messenger_popup() abort
  call nvim_win_set_option(0, 'winhl', 'Normal:NormalNC')

    " For example, set go back/forward history to <C-o>/<C-i>
    nmap <buffer><C-o> o
    nmap <buffer><C-i> O
endfunction

" AUTOCOMMANDS
augroup vimrc 
au! 

  " close additional wins
  au QuitPre * lua util.closeWin() 

  " onEnter
  au TermEnter,WinEnter,BufEnter * nested lua util.onEnter() 

  " dim active win
  au VimEnter,WinEnter,TermEnter,BufEnter,BufNew * lua util.dimWin() 
  au WinLeave * lua util.undimWin() 
  "au FocusGained,VimEnter,WinEnter,TermEnter,BufEnter,BufNew * lua util.dimWin() 
  "au FocusLost,WinLeave * lua util.undimWin() 

  " hide statusline on non-active windows
  au FocusGained,VimEnter,WinEnter,BufEnter * lua statusline.active() 
  au FocusLost,WinLeave,BufLeave * lua statusline.inactive() 

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
  au BufWritePost ~/bitacora/* lua require'markdown'.asyncPush() 

  " git-git-messenger
  autocmd FileType gitmessengerpopup call <SID>setup_git_messenger_popup()

augroup END 

" COMMANDS
command! HubberReports :ListIssues<space>github/pe-security-lab<space>labels:Vulnerability\<space>report<space>assignee:none
command! VulnReports :ListIssues<space>github/securitylab_vulnerabilities

" LUA INIT
lua require'init'

" MODULES
lua require'markdown'

" PLUGINS
lua require'plugins'

" MAPPINGS
lua require'mappings'

" TODO: consider adding the following mappings to the lua file
nnoremap <silent> [b    :bprevious<cr>
nnoremap <silent> ]b    :bnext<cr>
nnoremap <silent> [q    :cprevious<cr>
nnoremap <silent> ]q    :cnext<cr>
nnoremap <silent> [l    :lprevious<cr>
nnoremap <silent> ]l    :lnext<cr>
nnoremap <silent> [t    :tabprevious<cr>
nnoremap <silent> ]t    :tabnext<cr>
nnoremap gx :call OpenURL()<CR>
tnoremap <Esc> <C-\><C-n>

