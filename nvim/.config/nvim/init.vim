" GENERAL {{{
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
" }}}

" SYNTAX/LAYOUT {{{
syntax enable
set wrap                                                          " Wrap lines visually
set sidescroll=1                                                  " Side scroll when wrap is disabled
set linebreak                                                     " Wrap lines at special characters instead of at max width
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
"autocmd BufEnter *.* if getfsize(@%) < 1000000 | :syntax sync fromstart | endif " Detect syntax from start of file
" }}}

" LANGUAGE SPECIFICS {{{
let msql_sql_query = 1                                            " Better mysql highlight
let python_highlight_all = 1                                      " Better python highlight
let c_comment_strings=1                                           " Strings and numbers inside a comment
let c_syntax_for_h=1                                              " .h are C
let php_htmlInStrings = 1                                         " Highlight HTML in PHP strings
let php_sql_query = 1                                             " Highligh SQL in PHP
let java_highlight_all=1                                          " Better java highlight
let java_highlight_debug=1                                        " Highlight debug statement (println...)
let java_highlight_java_lang_ids=1                                " Highlight identifiers in java.lang.*
let java_highlight_functions="style"                              " Follow Java guidelines for Class and Function naming
let java_minlines = 150                                           " Start syntax sync 150 above current line
let java_comment_strings=1                                        " Strings and numbers inside a comment
let g:sh_no_error = 1                                             " Shell scrpting highlighting fixes
let g:markdown_fenced_languages = ['python', 'java', 'vim']       " Highlight fenced code
" }}}

" FOLDING {{{
set foldmethod=manual                                             " Fold manually (zf)
set foldcolumn=0                                                  " Do not show fold levels in side bar
" }}}

" UI {{{
set cursorline                                                    " Print cursorline
set guioptions=-Mfl                                               " nomenu, nofork, scrollbar
set laststatus=2                                                  " status line always on
set showtabline=2                                                 " always shows tabline
set lazyredraw                                                    " Don't update the display while executing macros
set number                                                        " Print the line number
set scrolloff=5                                                   " 5 lines margin to the cursor when moving
set tw=1000                                                       " TextWitdh ulra high since its used for active window highlighting
set t_Co=256                                                      " 256 colors
set ttyfast                                                       " Faster redraw
set showcmd                                                       " Show partial commands in status line
set noshowmode                                                    " Dont show the mode in the command line
autocmd BufEnter *.* :set colorcolumn=0                           " Dont show column
if (has("termguicolors"))                                         " Set true colors
    set termguicolors
endif
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" MOUSE {{{
behave xterm                                                      " Behave like xterm
if has('mouse')
    set mouse=a                                                   " Mouse support
    if !has('nvim')
        set ttymouse=xterm2
    endif
    set mousefocus                                                " Autofocus
    set mousehide                                                 " Hide mouse pointer while typing
endif
" }}}

" AUTOCOMPLETION {{{
set wildmenu wildmode=longest:full
set wildoptions=tagfile
set wildignorecase
set complete=.,w,b,u,U,i,d,t
set completeopt=menu,longest
set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore+=.sass-cache/*
" }}}

" BACKUP/SAVE {{{
set wb                                                            " Make a backup before overwriting
set nobackup                                                      " But don't keep it
set noswapfile                                                    " Swap is evil
set undofile                                                      " Maintain undo history between sessions
silent !mkdir ~/.config/nvim/tmp > /dev/null 2>&1                 " Create tmp directory if it does not exist already
set directory=~/.config/nvim/tmp                                  " But do it always in the same place
set backupdir=~/.config/nvim/tmp                                  " But do it always in the same place
set undodir=~/.config/nvim/tmp                                    " But do it always in the same place
au FocusLost * :silent! wall
"set viewoptions=cursor,folds                                      " Set view options for saving/restoring
"autocmd BufWinLeave *.* mkview!
"autocmd BufWinEnter *.* silent! loadview
" }}}

" IDENT/STYLE {{{
set autoindent                                                    " Auto-ident
set smartindent                                                   " Smart ident
set shiftround                                                    " Round indent to multiple of 'shiftwidth'
set smarttab                                                      " Reset autoindent after a blank line
set expandtab                                                     " Tabs are spaces
set tabstop=4                                                     " How many spaces on tab
set softtabstop=4                                                 " One tab = 4 spaces
set shiftwidth=4                                                  " Reduntant with above
" }}}

"FILE EXPLORER
let g:netrw_liststyle=3                                           " tree-view
let g:netrw_banner=0                                              " no banner
let g:netrw_altv=1                                                " open files on right
let g:netrw_browse_split=4                                        " Open file in previous buffer
let g:netrw_preview=1                                             " open previews vertically
let g:netrw_winsize = -28                                         " absolute width of netrw window
let g:netrw_sort_sequence = '[\/]$,*'
com!  -nargs=* -bar -bang -complete=dir  Lexplore  call netrw#Lexplore(<q-args>, <bang>0)
fun! Lexplore(dir, right)
  if exists("t:netrw_lexbufnr")
  " close down netrw explorer window
  let lexwinnr = bufwinnr(t:netrw_lexbufnr)
  if lexwinnr != -1
    let curwin = winnr()
    silent! exe lexwinnr."wincmd w"
    close
    silent! exe curwin."wincmd w"
  endif
  unlet t:netrw_lexbufnr

  else
    " open netrw explorer window in the dir of current file
    " (even on remote files)
    let path = substitute(exists("b:netrw_curdir")? b:netrw_curdir : expand("%:p"), '^\(.*[/\\]\)[^/\\]*$','\1','e')
    exe (a:right? "botright" : "topleft")." vertical ".((g:netrw_winsize > 0)? (g:netrw_winsize*winwidth(0))/100 : -g:netrw_winsize) . " new"
    if a:dir != ""
      exe "Explore ".a:dir
    else
      exe "Explore ".path
    endif
    setlocal winfixwidth
    let t:netrw_lexbufnr = bufnr("%")
  endif
endfun
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          silent! exec expl_win_num . 'wincmd w'
          close
          silent! exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      silent! exec '1wincmd w'
      Lexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" MAPPINGS {{{
if has('nvim')
    " in OSX/tmux, c-h is mapped to bs, so mappping bs to C-w
    nmap <bs> <C-w>h
    " terminal mode escape (neovim)
    tnoremap jk <C-\><C-n>
endif

" quit all windows
command! Q execute "qa!"

" debug syntax
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<Return>

" escape to normal mode in insert mode
inoremap jk <ESC>

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<Return>

" automatically jump to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" quickly select text you pasted
noremap gP `[v`]`]`

" highlight last inserted text
nnoremap gI `[v`]

" go up/down onw visual line
map j gj
map k gk

" go to Beggining or End of line
nnoremap B ^
nnoremap E $

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" remove search highlights
noremap <silent>./ :nohlsearch<Return>

" disable paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" cycle through buffers
nnoremap <S-l> :bnext<Return>
nnoremap <S-h> :bprevious<Return>

" jump to last visited location
nnoremap <S-k> <C-^>

" save one keystroke
nnoremap ; :

" do not close windows when closing buffers
cabbrev bd <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bclose' : 'bdelete')<Return>

" save me from 1 files :)
cabbrev w1 <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w!' : 'w1')<Return>

" resize splits
nnoremap <silent> > :exe "vertical resize +5"<Return>
nnoremap <silent> < :exe "vertical resize -5"<Return>
nnoremap <silent> + :exe "resize +5"<Return>
nnoremap <silent> - :exe "resize -5"<Return>

" }}}

" LEADER MAPPINGS {{{

" space is your leader
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" navigate faster
nnoremap <Leader>j 15j
nnoremap <Leader>k 15k

" refresh syntax highlighting
"noremap <Leader>s <ESC>:syntax sync fromstart<Return>

" remove trailing spaces
nnoremap <Leader>c :%s/\s\+$//<Return>

" save file
nnoremap <Leader>w :w<Return>
nnoremap <Leader>W :w !sudo tee % > /dev/null

" paste keeping the default register
vnoremap <Leader>p "_dP

" copy & paste to system clipboard
vmap <Leader>y "*y

" show/hide line numbers
nnoremap <Leader>n :set nonumber!<Return>

" relative line numbering
nnoremap <Leader>r :set norelativenumber!<Return>

" set paste mode
nnoremap <Leader>p :set nopaste!<Return>

" Show syntax highlighting groups for word under cursor
nmap <Leader>z :call <SID>SynStack()<Return>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}

" PLUGINS {{{
if &compatible
  set nocompatible
endif
filetype off

if (!isdirectory(expand("$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $HOME/.config/nvim/dein/repos/github.com"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim"))
endif
set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
let s:dein_basepath = expand('~/.config/nvim/dein')
let s:dein_toml = expand('~/.config/nvim/rc.d/dein.toml')
if dein#load_state(s:dein_basepath)
    call dein#begin(s:dein_basepath, [expand('~/.config/nvim/init.vim'), s:dein_toml,])
    call dein#load_toml(s:dein_toml, {})
    call dein#end()
    call dein#save_state()
endif
if !has('vim_starting')
    call dein#call_hook('source')
    call dein#call_hook('post_source')
endif
filetype plugin indent on
" }}}
