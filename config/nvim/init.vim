set hidden                                                        " Hide buffers when unloaded
set visualbell                                                    " Silent please
set inccommand=nosplit                                            " Live preview for :substitute
set updatetime=750                                                " CursorHold waiting time
set noshowmode                                                    " Dont show the mode in the command line
set termguicolors
set sidescroll=5                                                  " Side scroll when wrap is disabled
set scrolloff=8                                                   " Start scrolling when we're 8 lines away from margins
set linebreak                                                     " Wrap lines at special characters instead of at max width
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
set diffopt+=vertical                                             " Show vimdiff in vertical splits
set diffopt+=algorithm:patience                                   " Use git diffing algorithm
set diffopt+=context:1000000                                      " Don't fold
set ttimeoutlen=10                                                " Use short timeout after Escape sequence in terminal mode (for keycodes)
set timeoutlen=1000
set shortmess=aoOstTWAIcqF
set shiftwidth=2                                                  " Reduntant with above
set tabstop=2                                                     " How many spaces on tab
set softtabstop=2                                                 " One tab = 2 spaces
set expandtab                                                     " Tabs are spaces
set smartindent                                                   " Smart indent
set shiftround                                                    " Round indent to multiple of 'shiftwidth'
set showtabline=2
set laststatus=2
set number
set relativenumber
set keywordprg=:help                                              " Press K to show help for word under cursor
set conceallevel=2
set concealcursor=nc
set wildmode=longest,full                                         " Stuff to ignore when tab completing
set wildoptions=pum
set pumblend=10
set wildignorecase
set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore=*.o,*.obj,*~                                                     
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg
set complete=.,w,b,u,U,i,d,t
set completeopt=menu,menuone,noselect                               
set noswapfile
set nobackup
set nowritebackup
silent !mkdir ~/.nvim/backups > /dev/null 2>&1
set undodir=~/.nvim/backups
set undofile
set ignorecase                                                    " Disable case-sensitive searches (override with \c or \C)
set smartcase                                                     " If the search term contains uppercase letters, do case-sensitive search
set shada=!,%,'1000,<1000,s100,h
set formatoptions-=a                                              " Auto formatting is BAD.
set formatoptions-=t                                              " Don't auto format my code. I got linters for that.
set formatoptions+=c                                              " In general, I like it when comments respect textwidth
set formatoptions+=q                                              " Allow formatting comments w/ gq
set formatoptions-=o                                              " O and o, don't continue comments
set formatoptions+=r                                              " But do continue when pressing enter.
set formatoptions+=n                                              " Indent past the formatlistpat, not underneath it.
set formatoptions+=j                                              " Auto-remove comments if possible.
set formatoptions-=2                                              " I'm not in gradeschool anymore
set nojoinspaces

" FUNCTIONS
function ToggleDirvish(arg) abort
  for w in nvim_list_wins()
    let bufnr = nvim_win_get_buf(w)
    if nvim_buf_get_option(bufnr, 'filetype') == 'dirvish'
      call nvim_win_close(w, 1)
      return
    endif
  endfor
  let l:arg = a:arg
  if l:arg == v:null | let l:arg = '' | endif
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
  au FocusGained,VimEnter,WinEnter,TermEnter,BufEnter,BufNew * lua util.dimWin() 
  au FocusLost,WinLeave * lua util.undimWin() 

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

  " clear the command line 3 secs after running any command
  autocmd CmdlineLeave : lua vim.defer_fn(function() vim.cmd('echo ""') end, 3000)

augroup END 

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
" swap lines
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
