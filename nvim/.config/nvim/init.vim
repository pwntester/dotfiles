if &compatible
  set nocompatible
endif
filetype off

" GENERAL {{{
set autowrite                                                     " Write on shell/make command
set fileencoding=utf-8                                            " All the way!
set nrformats=alpha,hex,octal                                     " Increment/decrement numbers. C-a,a (tmux), C-x
set shell=/bin/zsh                                                " ZSH ftw!
set visualbell                                                    " Silent please
set ffs=unix                                                      " Use Unix EOL
set hidden                                                        " Hide buffers when unloaded
set nottimeout

" SYNTAX/LAYOUT {{{
set wrap                                                          " Wrap lines visually
set sidescroll=1                                                  " Side scroll when wrap is disabled
set linebreak                                                     " Wrap lines at special characters instead of at max width
autocmd BufNewFile,BufRead *.gradle set filetype=groovy           " Auto-set syntax for gradle files
autocmd BufNewFile,BufRead *.m set filetype=objc                  " Auto-set syntax for objc files
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
highlight clear SignColumn                                        " Clear Sign column bg color
"autocmd BufEnter *.* if getfsize(@%) < 1000000 | :syntax sync fromstart | endif " Detect syntax from start of file

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
let g:markdown_fenced_languages = ['python', 'lua', 'sh', 'vim']  " Highlight fenced code

" FOLDING {{{
set foldmethod=manual                                             " Fold manually (zf)
set foldcolumn=0                                                  " Do not show fold levels in side bar

" UI {{{
set cursorline                                                    " Print cursorline
set guioptions=-Mfl                                               " nomenu, nofork, scrollbar
set laststatus=2                                                  " status line always on
set lazyredraw                                                    " Don't update the display while executing macros
set number                                                        " Print the line number
set scrolloff=5                                                   " 5 lines margin to the cursor when moving
set t_Co=256                                                      " 256 colors
set ttyfast                                                       " Faster redraw
set showcmd                                                       " Show partial commands in status line

" MOUSE {{{
behave xterm                                                      " Behave like xterm
if has('mouse')
    set mouse=a                                                     " Mouse support
    if !has('nvim')
        set ttymouse=xterm2
    endif
    set mousefocus                                                  " Autofocus
    set mousehide                                                   " Hide mouse pointer while typing
endif

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

" BACKUP/SAVE {{{
set wb                                                            " Make a backup before overwriting
set nobackup                                                      " But don't keep it
set swapfile                                                      " Swap is good.
set directory=~/.config/nvim/tmp/swap/                            " But do it always in the same place
set backupdir=~/.config/nvim/tmp/backup/                          " But do it always in the same place
set undodir=~/.config/nvim/tmp/undo/                              " But do it always in the same place
au FocusLost * :silent! wall

" VIEWS {{{
set viewoptions=cursor,folds                                      " Set view options for saving/restoring
autocmd BufWinLeave *.* mkview!
autocmd BufWinEnter *.* silent! loadview

" IDENT/STYLE {{{
set autoindent                                                    " Auto-ident
set smartindent                                                   " Smart ident
set smarttab                                                      " Reset autoindent after a blank line
set expandtab                                                     " Tabs are spaces
set tabstop=4                                                     " How many spaces on tab
set softtabstop=4                                                 " One tab = 4 spaces
set shiftwidth=4                                                  " Reduntant with above
set shiftround                                                    " Round indent to multiple of 'shiftwidth'

" MAPPINGS {{{

" in OSX/tmux, c-h is mapped to bs, so mappping bs to C-w
if has('nvim')
    nmap <bs> <C-w>h
endif

" terminal mode escape (neovim)
if has('nvim')
    tnoremap jk <C-\><C-n>
endif

" quit all windows
command! Q execute "qa!"

" refresh syntax highlighting
noremap <F11> <ESC>:syntax sync fromstart<Return>
inoremap <F11> <ESC>:syntax sync fromstart<Return>a

" space to place the cursor in the middle of the screen
nnoremap <Space>j <C-d>
nnoremap <Space>k <C-u>

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
noremap <silent>\ :nohls<Return>

" disable paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" cycle through buffers
nnoremap <S-l> :bnext<Return>
nnoremap <S-h> :bprevious<Return>

" jump to last visited location
nnoremap <S-k> <C-^>

" LEADER MAPPINGS {{{

" remove trailing spaces
nnoremap <leader>c :%s/\s\+$//<Return>

" space is your leader
let mapleader = ","

" save file
nnoremap <leader>w :w<Return>
nnoremap <leader>W :w !sudo tee % > /dev/null

" paste keeping the default register
vnoremap <leader>p "_dP

" copy & paste to system clipboard
vmap <leader>y "*y

" show/hide line numbers
nnoremap <leader>n :set nonumber!<Return>

" relative line numbering
nnoremap <leader>r :set norelativenumber!<Return>

" set paste mode
nnoremap <leader>p :set nopaste!<Return>

" PLUGINS {{{
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

colorscheme cobalt2
syntax on                                                         " Activate the syntax
filetype plugin indent on                                         " Automatic recognition of filetype
