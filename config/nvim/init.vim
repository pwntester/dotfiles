" ================ PLUGINS ==================== {{{
" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

if exists('*minpac#init')
  call minpac#init()

  " Manually loaded plugins
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Auto loaded plugins
  call minpac#add('w0rp/ale', { 'do': '!npm install -g prettier' })
  call minpac#add('Shougo/defx.nvim')
  call minpac#add('Shougo/deoplete.nvim')
  call minpac#add('zchee/deoplete-jedi')
  call minpac#add('andymass/vim-matchup')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('junegunn/fzf', { 'do': '!./install --all && ln -s $(pwd) ~/.fzf'})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('pbogut/fzf-mru.vim')
  call minpac#add('tomtom/tcomment_vim')
  call minpac#add('osyo-manga/vim-anzu')
  call minpac#add('haya14busa/vim-asterisk')
  call minpac#add('regedarek/ZoomWin')
  call minpac#add('Yggdroot/indentLine')
  call minpac#add('matze/vim-move')
  call minpac#add('pwntester/cobalt2.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('maximbaz/lightline-ale')
  call minpac#add('t9md/vim-choosewin')
  call minpac#add('chaoren/vim-wordmotion')
  call minpac#add('junegunn/rainbow_parentheses.vim')
  call minpac#add('alvan/vim-closetag')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('benmills/vimux')
  call minpac#add('ap/vim-css-color')
  call minpac#add('cohama/lexima.vim')
  call minpac#add('SirVer/ultisnips')
  call minpac#add('honza/vim-snippets')
  call minpac#add('AndrewRadev/linediff.vim')
  call minpac#add('rbgrouleff/bclose.vim')
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('elzr/vim-json')
  call minpac#add('b4winckler/vim-objc')
  call minpac#add('kballard/vim-swift')
  call minpac#add('othree/xml.vim')
  call minpac#add('derekwyatt/vim-scala')
  call minpac#add('ekalinin/Dockerfile.vim')
  call minpac#add('tfnico/vim-gradle')
  call minpac#add('dyng/ctrlsf.vim')
  call minpac#add('autozimu/LanguageClient-neovim', { 'do': '!bash install.sh' })
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
" }}}

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
let g:loaded_netrwPlugin = 1                                      " Do not load netrw
let g:loaded_matchit = 1                                          " Do not load matchit, use matchup plugin
set signcolumn=yes                                                " Always draw the signcolumn

" }}}

" ================ SYNTAX ==================== {{{
syntax enable
set wrap                                                          " Wrap lines visually
set sidescroll=5                                                  " Side scroll when wrap is disabled
set scrolloff=8                                                   " Start scrolling when we're 8 lines away from margins
set linebreak                                                     " Wrap lines at special characters instead of at max width
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
"autocmd BufEnter *.* if getfsize(@%) < 1000000 | :syntax sync fromstart | endif " Detect syntax from start of file
" }}}

" ================ LANGUAGE SPECIFICS ==================== {{{
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

" ================ FOLDING ==================== {{{
set foldmethod=manual                                             " Fold manually (zf)
set foldcolumn=0                                                  " Do not show fold levels in side bar
" }}}

" ================ UI ==================== {{{
set cursorline                                                    " Print cursorline
set guioptions=-Mfl                                               " nomenu, nofork, scrollbar
set laststatus=2                                                  " status line always on
set showtabline=2                                                 " always shows tabline
set lazyredraw                                                    " Don't update the display while executing macros
set number                                                        " Print the line number
set tw=1000                                                       " TextWitdh ulra high since its used for active window highlighting
set t_Co=256                                                      " 256 colors
set ttyfast                                                       " Faster redraw
set showcmd                                                       " Show partial commands in status line
set noshowmode                                                    " Dont show the mode in the command line
if (has("termguicolors"))                                         " Set true colors
    set termguicolors
endif

" }}}

" ================ AUTOCOMPLETION ==================== {{{
set wildmode=list:full
set wildoptions=tagfile
set wildignorecase
set complete=.,w,b,u,U,i,d,t
set completeopt=menu,longest
set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore+=.sass-cache/*
set wildignore=*.o,*.obj,*~                                                     "stuff to ignore when tab completing
set wildignore+=*.git*
set wildignore+=*.meteor*
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*cache*
set wildignore+=*logs*
set wildignore+=*node_modules/**
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg
" }}}

" ================ TURN OFF SWAP FILES ==================== {{{
set noswapfile
set nobackup
set nowritebackup
" }}}

" ================ PERSISTENT UNDO ==================== {{{
silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
set undodir=~/.config/nvim/backups
set undofile
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

" ================ AUTOCOMMANDS ==================== {{{
augroup vimrc
    autocmd BufEnter *.* :set colorcolumn=0                       " Dont show column
    autocmd BufWritePre * call StripTrailingWhitespaces()         " Auto-remove trailing spaces
    autocmd FocusGained,BufEnter * checktime                      " Refresh file when vim gets focus
    autocmd VimEnter * nested colorscheme cobalt2
    autocmd BufEnter * nested :RainbowParentheses
    autocmd FileType markdown nested setlocal spell complete+=kspell
    autocmd BufNewFile,BufRead *.gradle nested set filetype=groovy
    autocmd BufEnter *.* nested if getfsize(@%) > 1000000 | call deoplete#disable() | endif
    autocmd FileType defx call DefxSettings()
    autocmd VimEnter * if argc() ==? 0 || isdirectory(expand('%:p')) | call DefxOpen() | endif
    autocmd BufReadPre,FileReadPre * call s:DelDefxBuffer()
augroup END

augroup windows
    autocmd!
    " Show cursor line only in active windows
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " Highlight active window
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn=join(range(1, 800), ',')
    autocmd FocusLost,WinLeave * let &l:colorcolumn='+' . join(range(0, 800), ',+')
augroup END
" }}}

" ================ MAPPINGS ==================== {{{
if has('nvim')
    " in OSX/tmux, c-h is mapped to bs, so mappping bs to C-w
    nmap <bs> <C-w>h
    " terminal mode escape (neovim)
    tnoremap jk <C-\><C-n>
endif

" center after search
nnoremap n nzz
nnoremap N Nzz

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

map <silent> <C-E> :Defx<CR>

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

" resize splits
nnoremap <silent> > :exe "vertical resize +5"<Return>
nnoremap <silent> < :exe "vertical resize -5"<Return>
nnoremap <silent> + :exe "resize +5"<Return>
nnoremap <silent> - :exe "resize -5"<Return>

" do not close windows when closing buffers
cabbrev bd <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bclose' : 'bdelete')<Return>

" save me from 1 files :)
cabbrev w1 <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w!' : 'w1')<Return>
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Wqa wqa
cnoreabbrev W w
" }}}

" ================ LEADER MAPPINGS ==================== {{{

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
nnoremap w!! w !sudo tee % >/dev/null

" paste keeping the default register
vnoremap <Leader>p "_dP

" copy & paste to system clipboard
vmap <Leader>y "*y

" show/hide line numbers
nnoremap <Leader>n :set nonumber!<Return>

" Language client context menu
nnoremap <Leader>r :call LanguageClient_contextMenu()<CR>

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

" ================ FUNCTIONS ======================== {{{

function! StripTrailingWhitespaces()
  if &modifiable
    let l:l = line('.')
    let l:c = col('.')
    call execute('%s/\s\+$//e')
    call histdel('/', -1)
    call cursor(l:l, l:c)
  endif
endfunction

function! DefxOpen(...) abort
  let l:find_current_file = a:0 > 0

  if !l:find_current_file
    return execute(printf('Defx %s', getcwd()))
  endif

  let l:current_file_name = escape(expand('%:p:t'), './')
  call execute(printf('Defx %s', expand('%:p:h')))
  return search(l:current_file_name)
endfunction

function! DefxSettings() abort
    nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
    nnoremap <silent><buffer><expr> o defx#do_action('open')
    nnoremap <silent><buffer><expr> N defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> n defx#do_action('new_file')
    nnoremap <silent><buffer><expr> d defx#do_action('remove')
    nnoremap <silent><buffer><expr> r defx#do_action('rename')
    nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
    nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer> q :call execute("bn\<BAR>bw#")<CR>
    setlocal nobuflisted
endfunction

function! s:DelDefxBuffer()
  if bufexists("[defx]")
    exe 'bdelete \[defx\]'
  endif
endfunction

" }}}

" ================ PLUGIN SETUPS ======================== {{{

" ZOOMWIN
nmap <leader>z <Plug>ZoomWin

" INDENTLINE
let g:indentLine_color_gui = '#17252c'
let g:indentLine_fileTypeExclude = ['fortifytestpane', 'fortifyauditpane']

" FZF
nnoremap <leader>h :History<Return>
nnoremap <leader>b :Buffers<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>d :Files<Return>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~40%' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" FZF-MRU
nnoremap <leader>m :FZFMru<Return>

" VIM-MOVE
let g:move_map_keys = 0
vmap ∆ <Plug>MoveBlockDown
vmap ˚ <Plug>MoveBlockUp
nmap ∆ <Plug>MoveLineDown
nmap ˚ <Plug>MoveLineUp

" COBALT2
set background=dark

" LIGHTLINE
execute 'source' fnameescape(expand('~/.config/nvim/lightline.vim'))

" CHOOSEWIN
nmap <C-w><C-w> <Plug>(choosewin)

" VIM-WORDMOTION
let g:wordmotion_prefix = '<Leader>'

" VIM-CLOSETAG
let g:closetag_filenames = "*.xml,*.html,*.xhtml,*.phtml"

" LEXIMA
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_space_rules = 1
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1

" ULTISNIPS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" DEOPLETE
let g:deoplete#enable_at_startup = 1
nnoremap <leader>c :call deoplete#toggle()<Cr>
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ""
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ">"

" VIM-MARKDOWN
let g:vim_markdown_folding_disabled = 1

" VIM-FORTIFY
nnoremap <leader>i :NewRuleID<Return>
let g:fortify_SCAPath = "/Applications/HP_Fortify/sca"
let g:fortify_PythonPath = "/usr/local/lib/python2.7/site-packages"
let g:fortify_AndroidJarPath = "/Users/alvaro/Library/Android/sdk/platforms/android-26/android.jar"
let g:fortify_DefaultJarPath = "/Applications/HP_Fortify/default_jars"
let g:fortify_MemoryOpts = [ "-Xmx4096M", "-Xss24M", "-64" ]
let g:fortify_JDKVersion = "1.8"
let g:fortify_XCodeSDK = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
let g:fortify_AWBOpts = []
let g:fortify_TranslationOpts = []
    " \ "-python-legacy",
let g:fortify_ScanOpts = [
    \ "-Dcom.fortify.sca.limiters.MaxChainDepth=10",
    \ "-Dcom.fortify.sca.limiters.MaxPassthroughChainDepth=10",
    \ "-Dcom.fortify.sca.DebugNumericTaint=true",
    \ "-Dcom.fortify.sca.ReportTrippedDepthLimiters=true",
    \ "-Dcom.fortify.sca.ReportTrippedNodeLimiters=true",
    \ "-Dcom.fortify.sca.ReportTightenedLimits=true",
    \ "-Dcom.fortify.sca.alias.mode.scala=fi",
    \ "-Dcom.fortify.sca.alias.mode.swift=fi",
    \ "-Dcom.fortify.sca.Phase0HigherOrder.Level=1",
    \ "-Dcom.fortify.sca.Phase0HigherOrder.Languages=javascript",
    \ "-Dcom.fortify.sca.EnableDOMModeling=true",
\]
    " \ "-debug", "-debug-verbose", "-logfile", "scan.log",
    " \ "-Ddebug.dump-nst",
    " \ "-Ddebug.dump-cg",
    " \ "-Ddebug.dump-call-targets",
    " \ "-Ddf3.debug=taint.log",
augroup fortify
    autocmd BufNewFile,BufReadPost *.xml nested map R ,R
    autocmd BufNewFile,BufReadPost *.rules nested map R ,R
    autocmd BufNewFile,BufReadPost *.xml nested map r ,r
    autocmd BufNewFile,BufReadPost *.rules nested map r ,r
    autocmd FileType fortifydescription nested setlocal spell complete+=kspell
    autocmd FileType fortifyrulepack nested setlocal omnifunc=fortify#complete
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-l> ""
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-h> ""
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-k> ""
augroup END
noremap <C-s> :execute substitute('/'.@0,'0$','','g')<CR>                       " search for contents of register 0 (where AuditPane copies the RuleIDs)

" ALE
let g:ale_linters = {'javascript': ['eslint']}                                  "Lint js with eslint
let g:ale_fixers = {'javascript': ['prettier', 'eslint']}                       "Fix eslint errors
let g:ale_javascript_prettier_options = '--print-width 100'                     "Set max width to 100 chars for prettier
let g:ale_sign_error = '✖'                                                      "Lint error sign
let g:ale_sign_warning = '⚠'                                                    "Lint warning sign

" MATCHUP
let g:matchup_matchparen_status_offscreen = 0                                   "Do not show offscreen closing match in statusline
let g:matchup_matchparen_nomode = "ivV\<c-v>"                                   "Enable matchup only in normal mode
let g:matchup_matchparen_deferred = 1                                           "Defer matchup highlights to allow better cursor movement performance

" LANGUAGE CLIENT
nnoremap <Leader>r :call LanguageClient_contextMenu()<CR>
let g:LanguageClient_serverCommands = {
\ 'javascript': ['javascript-typescript-stdio'],
\ 'javascript.jsx': ['javascript-typescript-stdio'],
\ 'typescript': ['javascript-typescript-stdio'],
\ 'python': ['/usr/local/bin/pyls'],
\ }

" ANZU
nmap n <Plug>(anzu-n)zz
nmap N <Plug>(anzu-N)zz

" ASTERISK
map * <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)
map # <Plug>(asterisk-z#)<Plug>(anzu-update-search-status)
map g* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)
map g# <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status)

" CTRLSF
let g:ctrlsf_auto_close = 0                                                     "Do not close search when file is opened
let g:ctrlsf_mapping = {'vsplit': 's'}                                          "Mapping for opening search result in vertical split


"}}}
