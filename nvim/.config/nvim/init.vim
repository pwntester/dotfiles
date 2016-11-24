set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')
  " Plug 'Shougo/unite.vim'                                           " Fuzzy searching
  " Plug 'Shougo/vimfiler.vim'                                        " File explorer
  Plug 'Shougo/denite.nvim'                                          " Fuzzy searching
  Plug 'Shougo/neomru.vim'                                          " Fuzzy searching for most recent used files
  Plug 'scrooloose/nerdtree'                                        " File explorer
  Plug 'Xuyuanp/nerdtree-git-plugin'                                " NERDTree plugin for showing git changes
  Plug 'Shougo/neosnippet.vim'                                      " Snippets engine
  Plug 'Shougo/neosnippet-snippets'                                 " Snippets
  Plug 't9md/vim-choosewin'                                         " Let you choose target window (plays well with vimfiler)
  Plug 'kana/vim-textobj-user'                                      " Allows text object customization
  Plug 'kana/vim-textobj-line'                                      " Text Objects for lines (l)
  Plug 'kana/vim-textobj-indent'                                    " Text Objects for indents (i)
  Plug 'whatyouhide/vim-textobj-xmlattr'                            " Text Objects for XML attributes (x)
  Plug 'bkad/CamelCaseMotion'                                       " Text Objects for CamelCase motion (,w)
  Plug 'tpope/vim-surround'                                         " Motions and Text Objects for surroundaing character(s)?
  Plug 'wellle/targets.vim'                                         " Add next (n) and last (l) to built-in Text Objects, also 'a' for arguments and separators (, . ; : + - = ~ _ * # / | \ & $)
  Plug 'tpope/vim-commentary'                                       " Comments
  Plug 'tpope/vim-fugitive'                                         " Git integration
  "Plug 'airblade/vim-gitgutter'                                     " Git integration
  Plug 'tpope/vim-repeat'                                           " Bundle commands as atomic and repeatable operations
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }     " Asynchronous completion
  Plug 'zchee/deoplete-jedi'                                        " Python completion for deoplete
  Plug 'zchee/deoplete-clang'                                       " Objective-C completion for deoplete
  Plug 'pwntester/deoplete-swift'                                   " Swift completion for deoplete
  Plug 'artur-shaik/vim-javacomplete2'                              " Java completion for omnifunc
  Plug 'christoomey/vim-tmux-navigator'                             " Tmux integration
  Plug 'ap/vim-css-color', {'for': ['css', 'html', 'php']}          " Shows CSS colors
  Plug 'gertjanreynaert/cobalt2-vim-theme'                          " Theme
  Plug 'godlygeek/tabular'                                          " Line up text
  Plug 'plasticboy/vim-markdown'                                    " Better syntax for markdown files
  Plug 'elzr/vim-json'                                              " Better syntax for JSON files
  Plug 'othree/yajs.vim', { 'for': 'javascript' }                   " Better syntax for JS
  Plug 'gavocanov/vim-js-indent'                                    " Better indentation for JS
  Plug 'b4winckler/vim-objc'                                        " Better syntax for Objective-C
  Plug 'kballard/vim-swift'                                         " Better syntax for Swift
  Plug 'othree/xml.vim'                                             " Better syntax for XML
  Plug 'derekwyatt/vim-scala'                                       " Better syntax for Scala
  Plug 'ekalinin/Dockerfile.vim'                                    " Better syntax for Docker
  Plug 'tfnico/vim-gradle'                                          " Gradle syntax and compiler integration
  Plug 'vim-airline/vim-airline'                                    " Nice status line
  Plug 'vim-airline/vim-airline-themes'                             " Airline themes
  Plug 'benekastah/neomake'                                         " Asynchronous linters
  Plug 'vim-scripts/vim-scroll-position'                            " Shows scroll position indicator in gutter
  Plug 'qpkorr/vim-bufkill'                                         " Delete buffers without messing around windows layout
  Plug 'henrik/vim-indexed-search'                                  " Search index
  Plug 'AndrewRadev/linediff.vim'                                   " File and chunk diffs
  Plug 'alvan/vim-closetag'                                         " Auto-close tags in HTML, XML, etc.
  Plug 'majutsushi/tagbar'                                          " Tag side menu
  Plug 'Raimondi/delimitMate'                                       " Auto-close parenthesis
  Plug 'junegunn/vader.vim'                                         " Testing vim plugins
  Plug 'junegunn/rainbow_parentheses.vim'                           " Quickly identify closing parenthesis
  Plug 'rizzatti/dash.vim'                                          " Query Dash from vim
  Plug 'https://github.hpe.com/alvaro-munoz/vim-fortify.git'        " Fortify SCA rule developement
  "Plug 'c0r73x/neotags.nvim'                                        " Generate ctags
call plug#end()

" GENERAL
  colorscheme cobalt2                                               " Beautiful Cobalt is beautiful
  set autowrite                                                     " Write on shell/make command
  set fileencoding=utf-8                                            " All the way!
  set encoding=utf8
  set nrformats=alpha,hex,octal                                     " Increment/decrement numbers. C-a,a (because of tmux), C-x
  set shell=/bin/zsh                                                " ZSH ftw!
  set visualbell                                                    " Silent please
  set ffs=unix                                                      " Use Unix EOL
  set hidden                                                        " Hide buffers when unloaded
  set nottimeout
  set shell=zsh

" SYNTAX/LAYOUT
  syntax on                                                         " Activate the syntax
  " hi CursorLine  cterm=none ctermbg=234 ctermfg=none guibg=234 guifg=none
  filetype plugin indent on                                         " Automatic recognition of filetype
  set modelines=1                                                   " Enable vim mode lines
  set wrap                                                          " Wrap lines visually
  set sidescroll=1                                                  " Side scroll when wrap is disabled
  set linebreak                                                     " Wrap lines at special characters instead of at max width
  autocmd BufNewFile,BufRead *.gradle set filetype=groovy           " Auto-set syntax for gradle files
  set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%          " Showing trailing whitespace
  highlight clear SignColumn                                        " Clear Sign column bg color
  "autocmd BufEnter *.* if getfsize(@%) < 1000000 | :syntax sync fromstart | endif " Detect syntax from start of file

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

  noremap m <ESC>:ApplyTransformer HealthVariant<CR>

  " Terminal mode escape (neovim)
  if has('nvim')
    tnoremap jk <C-\><C-n>
  endif

  " Quit all windows
  command! Q execute "qa!"

  " Refresh syntax highlighting
  noremap <F11> <ESC>:syntax sync fromstart<CR>
  inoremap <F11> <ESC>:syntax sync fromstart<CR>a

  " Remove  EOLs
  noremap <F10> <ESC>:%s///g<CR>

  " vim-over
  nnoremap <silent><F7> :OverCommandLine<CR>
  vnoremap <silent><F7> <Esc>:OverCommandLine<CR><F37>

  " Space to place the cursor in the middle of the screen
  nnoremap <Space>j <C-d>
  nnoremap <Space>k <C-u>

  " Escape to normal mode in insert mode
  inoremap jk <ESC>

  " Shifting visual block should keep it selected
  vnoremap < <gv
  vnoremap > >gv

  " Allow the . to execute once for each line of a visual selection
  vnoremap . :normal .<CR>

  " Automatically jump to end of text you pasted
  vnoremap <silent> y y`]
  vnoremap <silent> p p`]
  nnoremap <silent> p p`]

  " Quickly select text you pasted
  noremap gP `[v`]`]`

  " Highlight last inserted text
  nnoremap gI `[v`]

  " Go up/down onw visual line
  map j gj
  map k gk

  " Go to Beggining or End of line
  nnoremap B ^
  nnoremap E $

  " Disable arrow keys
  nnoremap <up> <nop>
  nnoremap <down> <nop>
  nnoremap <left> <nop>
  nnoremap <right> <nop>
  inoremap <up> <nop>
  inoremap <down> <nop>
  inoremap <left> <nop>
  inoremap <right> <nop>

  " Remove search highlights
  noremap <silent>\ :nohls<CR>

  " Disable paste mode when leaving Insert mode
  au InsertLeave * set nopaste

  " Cycle through buffers
  nnoremap <S-l> :bnext<CR>
  nnoremap <S-h> :bprevious<CR>

  " Jump to last visited location
  nnoremap <S-k> <C-^>

" LEADER MAPPINGS

  " Remove trailing spaces
  nnoremap <leader>c :%s/\s\+$//<cr>

  " Space is your leader
  let mapleader = ","

  " Fugitive
  nmap <leader>gs :Gstatus<CR>
  nmap <leader>ge :Gedit<CR>
  nmap <leader>gw :Gwrite<CR>
  nmap <leader>gr :Gread<CR>
  nmap <leader>gd :Gdiff<CR>

  " Save file
  nnoremap <leader>w :w<CR>
  nnoremap <leader>W :w !sudo tee % > /dev/null

  " Paste keeping the default register
  vnoremap <leader>p "_dP

  " Copy & paste to system clipboard
  vmap <leader>y "*y

  " Show/hide line numbers
  nnoremap <leader>n :set nonumber!<CR>

  " Relative line numbering
  nnoremap <leader>r :set norelativenumber!<CR>

  " Set paste mode
  nnoremap <leader>p :set nopaste!<CR>

  " Show last search index
  nnoremap <leader>i :%s///gn<CR>

  " unite mappings
  " nnoremap <leader>m :<C-u>Unite -start-insert file_mru<cr>
  " nnoremap <leader>b :<C-u>Unite bookmark<cr>

  " denite mappings
  nnoremap <leader>m :<C-u>Denite -start-insert file_mru<cr>
  nnoremap <leader>b :<C-u>Denite buffer<cr>

  " vimfiler. find current file in explorer buffer
  " nmap <leader>f :VimFilerBufferDir -explorer -find -parent<CR>
  " nmap <leader>e :VimFilerExplorer -parent<CR>

  " NERDTree
  nnoremap <silent> <Leader>f :NERDTreeFind<CR>
  nnoremap <Leader>e :NERDTreeToggle<Enter>

  " vim-fortify
  nnoremap <leader>i :NewRuleID<CR>

" PLUGINS

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
  " let g:fortify_FoldRules = 0
  " let g:fortify_DefaultIndentation = "structural"
  autocmd BufNewFile,BufReadPost *.xml map R ,R
  autocmd BufNewFile,BufReadPost *.rules map R ,R
  autocmd BufNewFile,BufReadPost *.xml map r ,r
  autocmd BufNewFile,BufReadPost *.rules map r ,r
  autocmd FileType fortifyrulepack setlocal omnifunc=fortify#Complete
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-l> ""
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-h> ""
  autocmd FileType fortifyauditpane nmap <buffer><expr> <S-k> ""

  " ListToggle
  let g:lt_location_list_toggle_map = '<leader>l'
  let g:lt_quickfix_list_toggle_map = '<leader>q'
  let g:lt_height = 25

  " neomake
  autocmd! BufWritePost * Neomake
  let g:neomake_javascript_enabled_checkers = ['jshint', 'jscs', 'eslint']
  let g:neomake_javascript_jscs_options = '--esnext'
  let g:neomake_airline = 1
  let g:neomake_error_sign = {'texthl': 'ErrorMsg'}
  hi MyWarningMsg ctermbg=3 ctermfg=0
  let g:neomake_warning_sign = {'texthl': 'MyWarningMsg'}
  let g:neomake_swift_swiftc_maker = {
        \ 'args': ['-parse', '-target', 'x86_64-apple-ios9.0', '-sdk', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk'],
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%Z%\s%#^~%#,' .
            \ '%-G%.%#',
        \ }
    let g:neomake_swift_enabled_makers = ['swiftc']


  " Deoplete.nvim
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
      \ "-isysroot", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator9.3.sdk",
      \ "-fmax-type-align=16",
      \ ]

  " vim-javacomplete2
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
  imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
  nmap <F5> <Plug>(JavaComplete-Imports-Add)
  imap <F5> <Plug>(JavaComplete-Imports-Add)
  nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
  imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
  nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

  " vim-closetag
  let g:closetag_filenames = "*.html,*.xhtml,*.xml,*.rules"

  " vim-indexed-search
  let g:indexed_search_max_lines = 400000
  let g:indexed_search_max_hits = 5000
  let g:indexed_search_colors = 0
  let g:indexed_search_shortmess = 1

  " unite
  " let g:unite_data_directory = '~/.config/nvim/unite'
  " call unite#filters#matcher_default#use(['matcher_fuzzy'])
  " call unite#filters#sorter_default#use(['sorter_rank'])
  " let g:unite_prompt='» '
  " call unite#custom#profile('default', 'context', {
  "   \   'winheight': 10,
  "   \   'direction': 'botright',
  "   \ })

  " denite
  call denite#custom#map('_', '<Esc>', 'quit')
  call denite#custom#map('insert', 'jk', 'enter_mode:normal')
  call denite#custom#map('insert', '<C-j>', 'move_to_next_line')
  call denite#custom#map('insert', '<C-k>', 'move_to_prev_line')
  "call denite#custom#source('file_mru', 'sorters', ['sorter_sublime'])
  call denite#custom#option('default', 'prompt', '>')
  call denite#custom#option('default', 'context', {
    \   'winheight': 10,
    \   'direction': 'botright',
    \ })

  " denite menu
  let s:menus = {}
  let s:menus.config = {'description': 'Edit configuration files'}
  let s:menus.config.file_candidates = [
    \ ['zshrc', '~/.zshrc'],
	\ ['zshprofile', '~/.zprofile'],
	\ ]
  let s:menus.fortify = {'description': 'Fortify'}
  let s:menus.fortify.command_candidates = [
	\ ['Translate current file', 'Translate %'],
	\ ['Scan current buildId with current buffer', 'Scan %'],
	\ ]
  let s:menus.commands = {'description': 'Fortify'}
  let s:menus.commands.command_candidates = [
	\ ['Configuration Files', 'Denite menu:config'],
	\ ['Fortify Commands', 'Denite menu:Fortify'],
	\ ]
  call denite#custom#var('menu', 'menus', s:menus)
 
  " vim-swift
  let g:swift_developer_dir = '/Applications/Xcode.app'
  let g:swift_platform = 'iphonesimulator'
  let g:swift_device = 'iPhone 6'

  " vimfiler
  " let g:vimfiler_as_default_explorer = 1
  " let g:vimfiler_no_default_key_mappings = 1
  " call vimfiler#custom#profile('default', 'context', {
  "   \   'explorer' : 1,
  "   \   'parent'   : 1,
  "   \   'no_focus' : 1,
  "   \   'safe'     : 0
  "   \ })
  " autocmd VimEnter * VimFilerExplorer -parent -direction=topleft
  " autocmd FileType vimfiler nmap <buffer><expr> <CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)","\<Plug>(vimfiler_edit_file)")
  " autocmd FileType vimfiler nmap <buffer><expr> <C-h> "\<Plug>(vimfiler_toggle_visible_ignore_files)"
  " autocmd FileType vimfiler nmap <buffer><expr> o "\<Plug>(vimfiler_expand_tree)"
  " autocmd FileType vimfiler nmap <buffer><expr> q "\<Plug>(vimfiler_close)"
  " autocmd FileType vimfiler nmap <buffer><expr> n "\<Plug>(vimfiler_make_directory)"
  " autocmd FileType vimfiler nmap <buffer><expr> f "\<Plug>(vimfiler_new_file)"
  " autocmd FileType vimfiler nmap <buffer><expr> r "\<Plug>(vimfiler_rename_file)"
  " autocmd FileType vimfiler nmap <buffer><expr> d "\<Plug>(vimfiler_delete_file)"
  " autocmd FileType vimfiler nmap <buffer><expr> <S-l> ""
  " autocmd FileType vimfiler nmap <buffer><expr> <S-h> ""
  " autocmd FileType vimfiler nmap <buffer><expr> <S-k> ""
  " autocmd FileType vimfiler setlocal nobuflisted
  
  " vim-plug
  autocmd FileType vim-plug nmap <buffer><expr> <S-l> ""
  autocmd FileType vim-plug nmap <buffer><expr> <S-h> ""
  autocmd FileType vim-plug nmap <buffer><expr> <S-k> ""

  " vim-bufkill
  cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'BD' : 'bdelete')<CR>
  cabbrev bd! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'BD!' : 'bdelete!')<CR>

  " vim-javascript
  let g:javascript_enable_domhtmlcss = 1

  " rainbow
  autocmd BufEnter * :RainbowParentheses

