if &compatible
  set nocompatible
endif
filetype off

set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.config/nvim/dein'))
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/neomru.vim') " Fuzzy searching for most recent used files
  call dein#add('Shougo/neosnippet') " Snippets engine
  call dein#add('Shougo/neosnippet-snippets') " Snippets
  call dein#add('Shougo/denite.nvim') " Fuzzy searching
  call dein#add('Shougo/vimfiler.vim') " File explorer
  call dein#add('Shougo/unite.vim') " (for vimfiler)
  call dein#add('t9md/vim-choosewin') " Let you choose target window
  call dein#add('kana/vim-textobj-user') " Allows text object customization
  call dein#add('kana/vim-textobj-line') " Text Objects for lines (l)
  call dein#add('kana/vim-textobj-indent') " Text Objects for indents (i)
  call dein#add('bkad/camelcasemotion') " Text Objects for CamelCase motion (,w)
  call dein#add('tpope/vim-surround') " Motions and Text Objects for surroundaing character(s)?
  call dein#add('tpope/vim-commentary') " Comments
  call dein#add('airblade/vim-gitgutter') " Git integration
  call dein#add('Shougo/deoplete.nvim') " Asynchronous completion
  call dein#add('zchee/deoplete-jedi') " Python completion for deoplete
  call dein#add('zchee/deoplete-clang') " Objective-C completion for deoplete
  call dein#add('pwntester/deoplete-swift') " Swift completion for deoplete
  call dein#add('artur-shaik/vim-javacomplete2') " Java completion for omnifunc
  call dein#add('christoomey/vim-tmux-navigator') " Tmux integration
  call dein#add('ap/vim-css-color') " Shows CSS colors
  call dein#add('gertjanreynaert/cobalt2-vim-theme') " Theme
  call dein#add('godlygeek/tabular') " Line up text
  call dein#add('plasticboy/vim-markdown') " Better syntax for markdown files
  call dein#add('elzr/vim-json') " Better syntax for JSON files
  call dein#add('othree/yajs.vim') " Better syntax for JS
  call dein#add('gavocanov/vim-js-indent') " Better indentation for JS
  call dein#add('b4winckler/vim-objc') " Better syntax for Objective-C
  call dein#add('kballard/vim-swift') " Better syntax for Swift
  call dein#add('othree/xml.vim') " Better syntax for XML
  call dein#add('derekwyatt/vim-scala') " Better syntax for Scala
  call dein#add('ekalinin/Dockerfile.vim') " Better syntax for Docker
  call dein#add('tfnico/vim-gradle') " Gradle syntax and compiler integration
  call dein#add('vim-airline/vim-airline') " Nice status line
  call dein#add('vim-airline/vim-airline-themes') " Airline themes
  call dein#add('benekastah/neomake') " Asynchronous linters
  call dein#add('vim-scripts/vim-scroll-position') " Shows scroll position indicator in gutter
  call dein#add('qpkorr/vim-bufkill') " Delete buffers without messing around windows layout
  call dein#add('henrik/vim-indexed-search') " Search index
  call dein#add('AndrewRadev/linediff.vim') " File and chunk diffs
  call dein#add('alvan/vim-closetag') " Auto-close tags in HTML, XML, etc.
  call dein#add('majutsushi/tagbar') " Tag side menu
  call dein#add('Raimondi/delimitMate') " Auto-close parenthesis
  call dein#add('junegunn/vader.vim') " Testing vim plugins
  call dein#add('junegunn/rainbow_parentheses.vim') " Quickly identify closing parenthesis
  call dein#add('rizzatti/dash.vim') " Query Dash from vim
  call dein#add('https://github.hpe.com/alvaro-munoz/vim-fortify.git') " Fortify SCA rule developement
call dein#end()

" GENERAL
  colorscheme cobalt2
  set autowrite                                                     " Write on shell/make command
  set fileencoding=utf-8                                            " All the way!
  set nrformats=alpha,hex,octal                                     " Increment/decrement numbers. C-a,a (tmux), C-x
  set shell=/bin/zsh                                                " ZSH ftw!
  set visualbell                                                    " Silent please
  set ffs=unix                                                      " Use Unix EOL
  set hidden                                                        " Hide buffers when unloaded
  set nottimeout

" SYNTAX/LAYOUT
  syntax on                                                         " Activate the syntax
  filetype plugin indent on                                         " Automatic recognition of filetype
  set wrap                                                          " Wrap lines visually
  set sidescroll=1                                                  " Side scroll when wrap is disabled
  set linebreak                                                     " Wrap lines at special characters instead of at max width
  autocmd BufNewFile,BufRead *.gradle set filetype=groovy           " Auto-set syntax for gradle files
  autocmd BufNewFile,BufRead *.m set filetype=objc                  " Auto-set syntax for objc files
  set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
  highlight clear SignColumn                                        " Clear Sign column bg color
  autocmd BufEnter *.* if getfsize(@%) < 1000000 | :syntax sync fromstart | endif " Detect syntax from start of file

" LANGUAGE SPECIFICS
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

" FOLDING
  set foldmethod=manual                                             " Fold manually (zf)
  set foldcolumn=0                                                  " Do not show fold levels in side bar

" UI
  set cursorline                                                    " Print cursorline
  set guioptions=-Mfl                                               " nomenu, nofork, scrollbar
  set laststatus=2                                                  " status line always on
  set lazyredraw                                                    " Don't update the display while executing macros
  set number                                                        " Print the line number
  set scrolloff=5                                                   " 5 lines margin to the cursor when moving
  set t_Co=256                                                      " 256 colors
  set ttyfast                                                       " Faster redraw
  set showcmd                                                       " Show partial commands in status line

" MOUSE
  behave xterm                                                      " Behave like xterm
  if has('mouse')
    set mouse=a                                                     " Mouse support
    if !has('nvim')
        set ttymouse=xterm2
    endif
    set mousefocus                                                  " Autofocus
    set mousehide                                                   " Hide mouse pointer while typing
  endif

" AUTOCOMPLETION
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

" BACKUP/SAVE
  set wb                                                            " Make a backup before overwriting
  set nobackup                                                      " But don't keep it
  set swapfile                                                      " Swap is good.
  set directory=~/.config/nvim/tmp/swap/                            " But do it always in the same place
  set backupdir=~/.config/nvim/tmp/backup/                          " But do it always in the same place
  set undodir=~/.config/nvim/tmp/undo/                              " But do it always in the same place
  au FocusLost * :silent! wall

" VIEWS
  set viewoptions=cursor,folds                                      " Set view options for saving/restoring
  autocmd BufWinLeave *.* mkview!
  autocmd BufWinEnter *.* silent! loadview

" IDENT/STYLE
  set autoindent                                                    " Auto-ident
  set smartindent                                                   " Smart ident
  set smarttab                                                      " Reset autoindent after a blank line
  set expandtab                                                     " Tabs are spaces
  set tabstop=4                                                     " How many spaces on tab
  set softtabstop=4                                                 " One tab = 4 spaces
  set shiftwidth=4                                                  " Reduntant with above
  set shiftround                                                    " Round indent to multiple of 'shiftwidth'

" AUTOLOAD
  augroup VimReload
  autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
  augroup END

" MAPPINGS

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

" LEADER MAPPINGS

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

  " denite
  nnoremap <leader>m :<C-u>Denite file_mru<Return>
  nnoremap <leader>b :<C-u>Denite buffer<Return>

  " vimfiler
  nmap <leader>f :VimFilerBufferDir -explorer -find -parent -winwidth=35<Return>
  nmap <leader>e :VimFilerExplorer -parent -winwidth=35<Return>

  " vim-fortify
  nnoremap <leader>i :NewRuleID<Return>

" PLUGINS

  " camelcasemotion
  map <silent> cw <Plug>CamelCaseMotion_w
  map <silent> cb <Plug>CamelCaseMotion_b
  map <silent> ce <Plug>CamelCaseMotion_e

  omap <silent> icw <Plug>CamelCaseMotion_iw
  xmap <silent> icw <Plug>CamelCaseMotion_iw
  omap <silent> icb <Plug>CamelCaseMotion_ib
  xmap <silent> icb <Plug>CamelCaseMotion_ib
  omap <silent> ice <Plug>CamelCaseMotion_ie
  xmap <silent> ice <Plug>CamelCaseMotion_ie

  " vim-airline
  au VimEnter * AirlineTheme powerlineish
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
  let g:airline#extensions#quickfix#location_text = 'Location'
  let g:airline#extensions#branch#enabled=1
  let g:airline#extensions#whitespace#enabled = 1
  let g:airline#extensions#tmuxline#enabled = 1
  if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"
  let g:airline_section_c = airline#section#create(['[', '%{getcwd()}', '] ', '%f'])
  
  " neosnippet
  let g:neosnippet#snippets_directory='/Users/alvaro/Development/GitRepos/vim-fortify/snippets'
  imap <tab> <Plug>(neosnippet_expand_or_jump)
  smap <tab> <Plug>(neosnippet_expand_or_jump)
  xmap <tab> <Plug>(neosnippet_expand_target)
  imap <expr><tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

  " vim-fortify
  let g:fortify_SCAPath = "/Applications/HP_Fortify/sca"
  let g:fortify_PythonPath = "/usr/local/lib/python2.7/site-packages"
  let g:fortify_AndroidJarPath = "/Users/alvaro/Library/Android/sdk/platforms/android-22/android.jar"
  "let g:fortify_AndroidJarPath = "/Users/alvaro/Library/Android/sdk/platforms/android-22/android-support-v7-appcompat.jar"
  let g:fortify_DefaultJarPath = "/Applications/HP_Fortify/default_jars"
  let g:fortify_MemoryOpts = [ "-Xmx4096M", "-Xss24M", "-64" ]
  let g:fortify_AWBOpts = []
  let g:fortify_ScanOpts = []
  let g:fortify_TranslationOpts = []
  let g:fortify_JDKVersion = "1.8"
  let g:fortify_XCodeSDK = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
  autocmd BufNewFile,BufReadPost *.xml map R ,R
  autocmd BufNewFile,BufReadPost *.rules map R ,R
  autocmd BufNewFile,BufReadPost *.xml map r ,r
  autocmd BufNewFile,BufReadPost *.rules map r ,r
  autocmd FileType fortifyrulepack setlocal omnifunc=fortify#Complete
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-l> ""
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-h> ""
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-k> ""

  " neomake
  autocmd! BufWritePost * Neomake
  let g:neomake_javascript_enabled_checkers = ['jshint', 'jscs', 'eslint']
  let g:neomake_javascript_jscs_options = '--esnext'
  let g:neomake_airline = 1
  highlight MyWarningStyle ctermbg=3 ctermfg=0
  let g:neomake_warning_sign = {'texthl': 'MyWarningStyle'}
  let g:neomake_error_sign = {'texthl': 'ErrorMsg'}
  let g:neomake_swift_enabled_makers = ['swiftc']
  let g:neomake_swift_swiftc_maker = {
        \ 'args': [
            \'-parse',
            \'-target', 'x86_64-apple-ios9.0',
            \'-sdk', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk'
        \ ],
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%Z%\s%#^~%#,' .
            \ '%-G%.%#',
        \ }
  let g:neomake_objc_enabled_makers = ['clang']
  let g:neomake_objc_clang_maker = {
        \ 'args': [
            \ '-cc1',
            \ '-triple', 'x86_64-apple-ios9.3.0',
            \ '-isysroot', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk',
            \ '-fmax-type-align=16',
            \ '-fshow-column ' .
            \ '-fshow-source-location ' .
            \ '-fno-caret-diagnostics ' .
            \ '-fno-color-diagnostics ' .
            \ '-fdiagnostics-format=clang' 
        \ ],
        \ 'errorformat':
            \ '%E%f:%l:%c: fatal error: %m,' .
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
            \ '%E%m'
        \ }
  " let g:neomake_objc_clang_maker = {
  "       \ 'args': ['-fsyntax-only', '-Wall', '-Wextra'],
  "       \ 'errorformat':
  "           \ '%-G%f:%s:,' .
  "           \ '%f:%l:%c: %trror: %m,' .
  "           \ '%f:%l:%c: %tarning: %m,' .
  "           \ '%f:%l:%c: %m,'.
  "           \ '%f:%l: %trror: %m,'.
  "           \ '%f:%l: %tarning: %m,'.
  "           \ '%f:%l: %m',
  "       \ }

  " deoplete.nvim
  let g:deoplete#enable_at_startup = 1
  autocmd BufEnter *.* if getfsize(@%) < 1000000 | let g:deoplete#disable_auto_complete = 0 | endif
  autocmd BufEnter *.* if getfsize(@%) > 1000000 | let g:deoplete#disable_auto_complete = 1 | endif
  inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ""
  inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ">"
  let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/3.9.0/lib/libclang.dylib'
  let g:deoplete#sources#clang#clang_header = '/usr/local/Cellar/llvm'
  let g:deoplete#sources#clang#flags = [
      \ "-cc1",
      \ "-triple", "x86_64-apple-ios9.3.0",
      \ "-isysroot", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
      \ "-fmax-type-align=16",
      \ ]

  " vim-javacomplete2
  autocmd FileType java setlocal omnifunc=javacomplete#Complete

  " vim-closetag
  let g:closetag_filenames = "*.html,*.xhtml,*.xml,*.rules"

  " vim-indexed-search
  let g:indexed_search_max_lines = 400000
  let g:indexed_search_max_hits = 5000
  let g:indexed_search_colors = 0
  let g:indexed_search_shortmess = 1

  " denite
  call denite#custom#map('_', '<esc>', 'quit')
  call denite#custom#map('insert', '<C-j>', 'move_to_next_line')
  call denite#custom#map('insert', '<C-k>', 'move_to_prev_line')
  call denite#custom#source('file_mru', 'sorters', ['sorter_sublime'])
  call denite#custom#option('default', 'prompt', '>')
  call denite#custom#option('default', 'winheight', 10)
  call denite#custom#option('default', 'reversed', 1)
  call denite#custom#option('default', 'auto_resize', 1)
  highlight default link  deniteMatched Keyword

  " vimfiler
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_no_default_key_mappings = 1
  call vimfiler#custom#profile('default', 'context', {
    \   'explorer' : 1,
    \   'parent'   : 1,
    \   'no_focus' : 1,
    \   'safe'     : 0
    \ })
  autocmd VimEnter * VimFilerExplorer -parent -direction=topleft -winwidth=25
  autocmd FileType vimfiler nmap <buffer><expr> <Return> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)","\<Plug>(vimfiler_edit_file)")
  autocmd FileType vimfiler nmap <buffer><expr> <C-h> "\<Plug>(vimfiler_toggle_visible_ignore_files)"
  autocmd FileType vimfiler nmap <buffer><expr> o "\<Plug>(vimfiler_expand_tree)"
  autocmd FileType vimfiler nmap <buffer><expr> q "\<Plug>(vimfiler_close)"
  autocmd FileType vimfiler nmap <buffer><expr> n "\<Plug>(vimfiler_make_directory)"
  autocmd FileType vimfiler nmap <buffer><expr> f "\<Plug>(vimfiler_new_file)"
  autocmd FileType vimfiler nmap <buffer><expr> r "\<Plug>(vimfiler_rename_file)"
  autocmd FileType vimfiler nmap <buffer><expr> d "\<Plug>(vimfiler_delete_file)"
  autocmd FileType vimfiler nmap <buffer><expr> <S-l> ""
  autocmd FileType vimfiler nmap <buffer><expr> <S-h> ""
  autocmd FileType vimfiler nmap <buffer><expr> <S-k> ""

  " vim-plug
  autocmd FileType vim-plug nmap <buffer><expr> <S-l> ""
  autocmd FileType vim-plug nmap <buffer><expr> <S-h> ""
  autocmd FileType vim-plug nmap <buffer><expr> <S-k> ""

  " vim-bufkill
  cabbrev bd <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'BD' : 'bdelete')<Return>
  cabbrev bd! <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'BD!' : 'bdelete!')<Return>

  " vim-javascript
  let g:javascript_enable_domhtmlcss = 1

  " rainbow
  autocmd BufEnter * :RainbowParentheses
