if &compatible 
    set nocompatible 
endif

" ================ PLUGINS ==================== {{{

" Disable built-in plugins
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_logipat           = 1
let g:loaded_logiPat           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_sql_completion    = 1
let g:loaded_syntax_completion = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:vimsyn_embed             = 1
let g:loaded_matchit           = 1 

" ================ GENERAL ==================== {{{
set autowrite                                                     " Write on shell/make command
set nrformats=alpha,hex,octal                                     " Increment/decrement numbers. C-a,a (tmux), C-x
set shell=/bin/zsh                                                " ZSH ftw!
set visualbell                                                    " Silent please
set ffs=unix                                                      " Use Unix EOL
set hidden                                                        " Hide buffers when unloaded
set inccommand=nosplit                                            " Live preview for :substitute
set fileencoding=utf-8
set encoding=utf-8
set nottimeout
set updatetime=800                                               " CursorHold waiting time
" }}}

" ================ UI ==================== {{{
set foldmethod=manual                                             " Fold manually (zf)
set foldcolumn=0                                                  " Do not show fold levels in side bar
set cursorline                                                    " Print cursorline
set guioptions=-Mfl                                               " nomenu, nofork, scrollbar
set laststatus=2                                                  " status line always on
set showtabline=2                                                 " always shows tabline
set lazyredraw                                                    " Don't update the display while executing macros
set number                                                        " Print the line number
set t_Co=256                                                      " 256 colors
set ttyfast                                                       " Faster redraw
set showcmd                                                       " Show partial commands in status line
set noshowmode                                                    " Dont show the mode in the command line
set signcolumn=auto                                               " Only sho sign column if there are signs to be shown
set termguicolors
set wrap                                                          " Wrap lines visually
set sidescroll=5                                                  " Side scroll when wrap is disabled
set scrolloff=8                                                   " Start scrolling when we're 8 lines away from margins
set linebreak                                                     " Wrap lines at special characters instead of at max width
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
set diffopt+=vertical                                             " Show vimdiff in vertical splits
set diffopt+=algorithm:patience                                   " Use git diffing algorithm

" syntax improvements
let g:java_highlight_all = 1
let g:java_space_errors = 1
let g:java_comment_strings = 1
let g:java_highlight_functions = 1
let g:java_highlight_debug = 1
let g:java_mark_braces_in_parens_as_errors = 1
" }}}

" ================ IDENT/STYLE ==================== {{{
set shiftwidth=4                                                  " Reduntant with above
set tabstop=4                                                     " How many spaces on tab
set softtabstop=4                                                 " One tab = 4 spaces
set expandtab                                                     " Tabs are spaces
set autoindent                                                    " Auto-ident
set smartindent                                                   " Smart ident
set shiftround                                                    " Round indent to multiple of 'shiftwidth'
set smarttab                                                      " Reset autoindent after a blank line
" }}}

" ================ COMPLETION ==================== {{{
set wildmode=longest,full                                         "stuff to ignore when tab completing
set wildmenu
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
set completeopt=menu,menuone,noinsert,noselect

set shortmess+=c                                                    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess-=F
" }}}

" ================ SWAP/UNDO FILES ==================== {{{
set noswapfile
set nobackup
set nowritebackup
silent !mkdir ~/.nvim/backups > /dev/null 2>&1
set undodir=~/.nvim/backups
set undofile
" }}}

" ================ SEARCH ==================== {{{
set ignorecase                                                    " Disable case-sensitive searches (override with \c or \C)
set smartcase                                                     " If the search term contains uppercase letters, do case-sensitive search
" }}}

" ================ AUTOCOMMANDS ==================== {{{
augroup vimrc
    " disable paste mode when leaving Insert mode
    autocmd InsertLeave * set nopaste
    " check if buffer was changed outside of vim
    autocmd FocusGained,BufEnter * checktime
    " spell check
    autocmd FileType markdown nested setlocal spell complete+=kspell
    " mark qf as not listed
    autocmd FileType qf setlocal nobuflisted 
    " force write shada on leaving nvim
    autocmd VimLeave * wshada!
augroup END

augroup active_win 
    " dont show column
    autocmd BufEnter *.* :set colorcolumn=0
    " show cursor line only in active windows
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " highlight active window
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=CursorLineNr:CursorLineNr,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
    autocmd FocusLost,WinLeave * set winhighlight=
augroup END

augroup numbertoggle
    autocmd!
    autocmd BufEnter * set relativenumber
    autocmd BufLeave * set norelativenumber
augroup END
" }}}

" ================ MAPPINGS ==================== {{{

" center after search
nnoremap n nzz
nnoremap N Nzz

" escape to normal mode in insert mode
inoremap jk <ESC>

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv|

" automatically jump to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" quickly select text you pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" go up/down onw visual line
map j gj
map k gk

" go to begining or End of line
nnoremap B ^
nnoremap E $

" disable keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <space> <nop>
nnoremap <esc> <nop>

" save one keystroke
nnoremap ; :

" resize splits
nnoremap <silent> > :execute "vertical resize +5"<Return>
nnoremap <silent> < :execute "vertical resize -5"<Return>
nnoremap <silent> + :execute "resize +5"<Return>
nnoremap <silent> - :execute "resize -5"<Return>

" move around command line wildmenu
cnoremap <C-k> <LEFT>
cnoremap <C-j> <RIGHT>
cnoremap <C-h> <Space><BS><Left>
cnoremap <C-l> <Space><BS><Right>

" buffer switching
nnoremap <S-l> :bnext<Return>
nnoremap <S-h> :bprevious<Return>

" window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" leader mappings
let mapleader = "\<Space>"

" navigate faster
nnoremap <Leader>j 12j
nnoremap <Leader>k 12k

" paste keeping the default register
vnoremap <Leader>p "_dP

" copy & paste to system clipboard
vmap <Leader>y "*y

" }}}

" ================ DEBUG ======================== {{{
function! Log(text) abort
    if 1 
        silent execute '!echo '.a:text.' >> /tmp/log'
    endif
endfunction

" debug syntax
nmap <silent> gs :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
	\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<Return>

" }}}

" ================ PIN SPECIAL BUFFERS ======================== {{{
let g:special_buffers = [
    \ 'help',
    \ 'fortifytestpane',
    \ 'fortifyauditpane',
    \ 'defx',
    \ 'dirvish',
    \ 'qf',
    \ 'vim-plug',
    \ 'fzf',
    \ 'magit',
    \ 'goterm',
    \ 'vista_kind',
    \ 'codeqltestpanel',
    \ 'codeqlauditpanel'
    \ ]
function! s:pinBuffer()
    " prevent changing buffer
    nnoremap <silent><buffer><S-l> <Nop>
    nnoremap <silent><buffer><S-h> <Nop>
    nnoremap <silent><buffer><leader>h <Nop>
    cmap <silent><buffer><expr>e<Space> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "e<Space>")
    cmap <silent><buffer><expr>bd<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bd<Return>")
    cmap <silent><buffer><expr>bp<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bp<Return>")
    cmap <silent><buffer><expr>bn<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bn<Return>")
    set nonumber
    set norelativenumber
endfunction

augroup windows
    autocmd!
    autocmd WinEnter,BufEnter *  nested if index(g:special_buffers, &filetype) > -1 | call s:pinBuffer() | endif
    autocmd WinEnter,BufEnter {} nested if index(g:special_buffers, &filetype) > -1 | call s:pinBuffer() | endif
    " BufEnter is not triggered for defx and dirvish buffer
    autocmd FileType defx call s:pinBuffer()
    autocmd FileType dirvish call s:pinBuffer()
augroup END
" }}}

" ================ ALIASES ======================== {{{
function! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
function! CloseWin()
    " When closing a window, close quit vim if it was the only window or if
    " the other windows have special buffers.
    if index(g:special_buffers, &filetype) > -1 
        " closing window with special buffer
        quit
    else
        " closing window with regular buffer
        let l:current_window = win_getid()
        let l:winids = nvim_list_wins()
        if len(l:winids) == 1
            " only window, closing
            quit
        elseif len(winids) > 1
            " other windows
            let l:non_special_buffers_count = 0
            for w in l:winids
                if index(g:special_buffers, nvim_buf_get_option(nvim_win_get_buf(w), 'filetype')) == -1 
                    let l:non_special_buffers_count = l:non_special_buffers_count + 1
                endif
            endfor
            if l:non_special_buffers_count == 1
                " only this window with regular buffer, rest are special ones.
                " close then all
                quitall
            else 
                " there are other windows with regular buffers, close only
                " this split
                call nvim_win_close(l:current_window, v:true)
            endif
        endif
    endif
endfunction
function! SetAliases() abort
    " close buffers without closing the window 
    call SetupCommandAlias("bd","bp<bar>sp<bar>bn<bar>bd")

    " close all buffers but the current one
    call SetupCommandAlias("bo","%bd<bar>e#<bar>bd#")

    " save me from 1 files :)
    call SetupCommandAlias("w1","w!")

    " close window 
    call SetupCommandAlias("q","call CloseWin()")

    "Alias q! quit!
    call SetupCommandAlias("wq","write<bar>call CloseWin()")

    "Alias wq! write|qa!
    call SetupCommandAlias("wq!","write<bar>qa!")

    command! -nargs=0 -bang Q quitall!<bang>
    command! -nargs=0 -bang W w!<bang>
    command! -nargs=0 -bang Wq wq!<bang>
    command! -nargs=0 B b#
endfunction
autocmd VimEnter * call SetAliases()
" }}}

" ================ PLUGIN SETUP ======================== {{{
execute 'source' fnameescape(expand('~/.config/nvim/plugins.vim'))

" }}}

" ================ POP-UP MENU (PUM) ======================== {{{
inoremap <silent><expr> <Return> pumvisible() ? "\<c-y>\<cr>" : "\<Return>"
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ''
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ''

" }}}

" ================ THEME ======================== {{{
syntax enable
set background=dark
colorscheme cobalt2

" NVIM-LSP
hi LspDiagnosticsError guifg=#FF0000
hi LspDiagnosticsWarning guifg=#FFC600
hi LspDiagnosticInformation guifg=#00AAFF
hi LspDiagnosticHint guifg=#00AAFF
hi LspDiagnosticsUnderline guifg=None gui=underline
hi LspReferenceText guibg=#9E9E9E guifg=#000000
hi LspReferenceRead guibg=#9E9E9E guifg=#000000
hi LspReferenceWrite guibg=#9E9E9E guifg=#000000

" VIM-GO
hi def link goDiagnosticError SpellBad
hi def link goDiagnosticWarning SpellRare

" DIRVISH
hi def link DirvishPathTail Comment
hi def link DirvishPathHead Function
hi def link DirvishSuffix Identifier

"}}}
