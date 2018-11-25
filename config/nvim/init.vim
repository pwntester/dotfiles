" ================ PLUGINS ==================== {{{
if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')
  Plug 'w0rp/ale', { 'do': '!npm install -g prettier' }
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins'}
  Plug 'autozimu/LanguageClient-neovim', { 'do': 'bash install.sh' }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
  Plug 'zchee/deoplete-jedi'
  Plug 'andymass/vim-matchup'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/fzf', { 'do': '!./install --all && ln -s $(pwd) ~/.fzf'}
  Plug 'junegunn/fzf.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'osyo-manga/vim-anzu'
  Plug 'haya14busa/vim-asterisk'
  Plug 'regedarek/ZoomWin'
  Plug 'Yggdroot/indentLine'
  Plug 'matze/vim-move'
  Plug 'pwntester/cobalt2.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 't9md/vim-choosewin'
  Plug 'chaoren/vim-wordmotion'
  Plug 'luochen1990/rainbow'
  Plug 'alvan/vim-closetag'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ap/vim-css-color'
  Plug 'cohama/lexima.vim'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'AndrewRadev/linediff.vim'
  Plug 'rbgrouleff/bclose.vim'
  Plug 'dyng/ctrlsf.vim'
  Plug 'brooth/far.vim', { 'do': ':UpdateRemotePlugins' }
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'majutsushi/tagbar'
  Plug 'plasticboy/vim-markdown'
  Plug 'elzr/vim-json'
  Plug 'b4winckler/vim-objc'
  Plug 'kballard/vim-swift'
  Plug 'othree/xml.vim'
  Plug 'derekwyatt/vim-scala'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'tfnico/vim-gradle'
  Plug 'tfnico/vim-gradle'
call plug#end()

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
set ignorecase                                                    " Disable case-sensitive searches (override with \c or \C)
set smartcase                                                     " If the search term contains uppercase letters, do case-sensitive search
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
"stuff to ignore when tab completing
set wildmode=longest,full
set wildoptions=tagfile
set wildignorecase
set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore+=.sass-cache/*
set wildignore=*.o,*.obj,*~                                                     
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

set complete=.,w,b,u,U,i,d,t
set completeopt=menu,longest
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
    " check if buffer was changed outside of vim
    autocmd FocusGained,BufEnter * checktime                      " Refresh file when vim gets focus
    " spell 
    autocmd FileType markdown nested setlocal spell complete+=kspell
    " cobalt2
    "autocmd VimEnter * nested colorscheme cobalt2
    " deoplete
    autocmd BufEnter *.* nested if getfsize(@%) > 1000000 | call deoplete#disable() | endif
    " defx
    autocmd FileType defx call DefxSettings()
    autocmd VimEnter * if argc() ==? 0 || isdirectory(expand('%:p')) | call DefxOpen() | endif
    autocmd BufReadPre,FileReadPre * call s:DelDefxBuffer()
    " fortify
    autocmd BufNewFile,BufReadPost *.xml nested map R ,R
    autocmd BufNewFile,BufReadPost *.rules nested map R ,R
    autocmd BufNewFile,BufReadPost *.xml nested map r ,r
    autocmd BufNewFile,BufReadPost *.rules nested map r ,r
    autocmd FileType fortifydescription nested setlocal spell complete+=kspell
    autocmd FileType fortifyrulepack nested setlocal omnifunc=fortify#complete
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-l> ""
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-h> ""
    autocmd FileType fortifyauditpane nested nmap <buffer><expr> <S-k> ""
    " lexima
    autocmd VimEnter *.* call lexima#add_rule({'char': '-', 'at': '<!-', 'input_after': ' -->', 'filetype': 'fortifyrulepack'})
augroup END

augroup windows
    autocmd!
    " Dont show column
    autocmd BufEnter *.* :set colorcolumn=0
    " Show cursor line only in active windows
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " Highlight active window
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn=join(range(1, 800), ',')
    autocmd FocusLost,WinLeave * let &l:colorcolumn='+' . join(range(0, 800), ',+')
augroup END
" }}}

" ================ MAPPINGS ==================== {{{
" in OSX/tmux, c-h is mapped to bs, so mappping bs to C-w
nmap <bs> <C-w>h
" terminal mode escape (neovim)
tnoremap jk <C-\><C-n>

" center after search
nnoremap n nzz
nnoremap N Nzz

" search for visual selection (exact matches, no regexp)
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

" search for contents of register 0 (where AuditPane copies the RuleIDs)
noremap /0 :execute substitute('/'.@0,'0$','','g')<CR>                                   

" remove search highlights
nnoremap <silent>./ :nohlsearch<Return>

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

nnoremap <silent> <C-e> :Defx -split=vertical -winwidth=50 -toggle<Return>
nnoremap <silent> <C-f> :call execute(printf('Defx -split=vertical -winwidth=50 -toggle %s -search=%s', expand('%:p:h'), expand('%:p')))<Return>

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

nnoremap <Leader>t :TagbarToggle<Return>

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

" set paste mode
nnoremap <Leader>p :set nopaste!<Return>

" }}}

" ================ FUNCTIONS ======================== {{{
let g:special_buffers = ['fortifytestpane', 'fortifyauditpane', 'tagbar', 'defx']

function! StripTrailingWhitespaces()
  if &modifiable
    let l:l = line('.')
    let l:c = col('.')
    call execute('%s/\s\+$//e')
    call histdel('/', -1)
    call cursor(l:l, l:c)
  endif
endfunction

function! DefxSettings() abort
    nnoremap <silent><buffer><expr> <CR> defx#do_action('open', 'DefxOpenCommand')
    nnoremap <silent><buffer><expr> y defx#do_action('copy')
	nnoremap <silent><buffer><expr> m defx#do_action('move')
	nnoremap <silent><buffer><expr> p defx#do_action('paste')
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

function! DefxOpenAction(path)
    set splitright
    let winnrs = range(1, tabpagewinnr(tabpagenr(), '$'))
    if len(winnrs) > 1
        for winnr in winnrs
            if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) == -1
                execute printf('%swincmd w', winnr)
                execute printf('%dvsplit %s', str2nr(&columns) - 50, a:path)
                return
            endif
        endfor
    endif

    " can't find suitable buffer.
    execute printf('%dvsplit %s', str2nr(&columns) - 50, a:path)
    set splitright&
endfunction
command! -nargs=* -range DefxOpenCommand call DefxOpenAction(<q-args>)

function! DefxOpen(...) abort
  let l:find_current_file = a:0 > 0

  if !l:find_current_file
    return execute(printf('Defx %s', getcwd()))
  endif

  let l:current_file_name = escape(expand('%:p:t'), './')
  call execute(printf('Defx %s', expand('%:p:h')))
  return search(l:current_file_name)
endfunction

function! s:DelDefxBuffer()
  if bufexists("[defx]")
    exe 'bdelete \[defx\]'
  endif
endfunction

function! FZFOpen(command_str)
    let winnrs = range(1, tabpagewinnr(tabpagenr(), '$'))
    if len(winnrs) > 1
        for winnr in winnrs
            if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) != -1 
                execute "normal! \<c-w>\<c-w>"
            endif
        endfor
    endif
    exe 'normal! ' . a:command_str . "\<cr>"
endfunction
" }}}

" ================ PLUGIN SETUPS ======================== {{{

" ZOOMWIN
nmap <leader>z <Plug>ZoomWin

" INDENTLINE
let g:indentLine_color_gui = '#17252c'
let g:indentLine_fileTypeExclude = g:special_buffers 

" FZF
nnoremap <leader>m :call FZFOpen(':History')<Return>
nnoremap <leader>h :call FZFOpen(':History')<Return>
nnoremap <leader>b :call FZFOpen(':Buffers')<Return>
nnoremap <leader>s :call FZFOpen(':Snippets')<Return>
nnoremap <leader>f :call FZFOpen('Files')<Return>

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

" VIM-MOVE
let g:move_map_keys = 0
vmap ∆ <Plug>MoveBlockDown
vmap ˚ <Plug>MoveBlockUp
nmap ∆ <Plug>MoveLineDown
nmap ˚ <Plug>MoveLineUp

" COBALT2
set background=dark
colorscheme cobalt2

" LIGHTLINE
execute 'source' fnameescape(expand('~/.config/nvim/lightline.vim'))

" CHOOSEWIN
nmap <C-w><C-w> <Plug>(choosewin)

" VIM-WORDMOTION
let g:wordmotion_prefix = '<Leader>'

" VIM-CLOSETAG
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsp'
let g:closetag_filetypes = 'html,xhtml,phtml,fortifyrulepack,xml,jsp'
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsp,*.html'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,fortifyrulepack'

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

let g:fortify_TranslationOpts = ["-Dcom.fortify.sca.fileextensions.csproj=XML"]
let g:fortify_TranslationOpts = ["-project-root", "sca_build"]
"let g:fortify_TranslationOpts = ["-debug", "-verbose", "-debug-verbose", "-logfile","sca_build/build.log"]
let g:fortify_TranslationOpts += ["-Dcom.fortify.sca.DefaultFileTypes=java,rb,jsp,jspx,tag,tagx,tld,sql,cfm,php,csproj,phtml,ctp,pks,pkh,pkb,xml,config,Config,settings,properties,dll,exe,winmd,cs,vb,asax,ascx,ashx,asmx,aspx,master,Master,xaml,baml,cshtml,vbhtml,inc,asp,vbscript,js,ini,bas,cls,vbs,frm,ctl,html,htm,xsd,wsdd,xmi,py,cfml,cfc,abap,xhtml,cpx,xcfg,jsff,as,mxml,cbl,cscfg,csdef,wadcfg,wadcfgx,appxmanifest,wsdl,plist,bsp,ABAP,BSP,swift,page,trigger,scala"]
"let g:fortify_TranslationOpts += ["-python-legacy"]
"let g:fortify_TranslationOpts += ["-python-version 3"]
let g:fortify_ScanOpts = ["-project-root", "sca_build"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.limiters.MaxChainDepth=10"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.limiters.MaxPassthroughChainDepth=10"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.limiters.MaxIndirectResolutionsForCall=512"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.DebugNumericTaint=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ReportTrippedDepthLimiters=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ReportTrippedNodeLimiters=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ReportTightenedLimits=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ReportUnresolvedCalls=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ReportTightenedLimits"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.alias.mode.scala=fi"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.alias.mode.swift=fi"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.Phase0HigherOrder.Level=1"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.Phase0HigherOrder.Languages=javascript,typescript"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.EnableDOMModeling=true"]
let g:fortify_ScanOpts += ["-Dcom.fortify.sca.followImports=false"]                              " Do not translate and analyze all libraries that you require in your code
let g:fortify_ScanOpts += ["-Ddebug.dump-nst", "sca_build"]                                      " For debugging purposes dumps NST files between Phase 1 and Phase 2 of analysis.
" let g:fortify_ScanOpts += ["-debug", "-debug-verbose", "-logfile", "sca_build/scan.log"]       " Generate scan logs
" let g:fortify_ScanOpts += ["-Ddebug.dump-cfg"]                                                 " For debugging purposes controls dumping Basic Block Graph to file.
" let g:fortify_ScanOpts += ["-Ddebug.dump-raw-cfg"]                                             " dump the cfg which is not optimized by dead code elimination
" let g:fortify_ScanOpts += ["-Ddebug.dump-ssi"]                                                 " For debugging purposes dump ssi graph.
" let g:fortify_ScanOpts += ["-Ddebug.dump-cg"]                                                  " For debugging purposes dump call graph.
" let g:fortify_ScanOpts += ["-Ddebug.dump-vcg"]                                                 " For debugging purposes dump virtual call graph deferred items.
" let g:fortify_ScanOpts += ["-Ddebug.dump-model"]                                               " For debugging purposes data dump of model attributes.
" let g:fortify_ScanOpts += ["-Ddebug.dump-call-targets"]                                        " For debugging purposes dump call targets for each call site.
" let g:fortify_ScanOpts += ["-Dic.debug=issue_calculator.log"]                                  " Dump issue calculator log
" let g:fortify_ScanOpts += ["-Ddf3.debug=taint.log"]                                            " Dump taint log
" let g:fortify_ScanOpts += ["-Dcom.fortify.sca.ThreadCount=1"]                                  " Disable multi-threading

" ALE
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'fortifyrulepack': ['ftfylinter'],
\}
"\   'java': ['javac'],
let g:ale_linters_explicit = 1                                                  " Only run linters named in ale_linters settings.
"let g:ale_fixers = {'javascript': ['prettier', 'eslint']}                       " Fix eslint errors
let g:ale_javascript_prettier_options = '--print-width 100'                     " Set max width to 100 chars for prettier
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'                                                      " Lint error sign
let g:ale_sign_warning = '⚠'                                                    " Lint warning sign
let g:ale_lint_on_enter = 0                                                     " Do not lint on enter
let g:ale_virtualtext_cursor= 1                                                 " Enable virtual text (EOL overlay)
let g:ale_echo_cursor= 0                                                        " Disble echoing errors in command line
let g:ale_virtualtext_prefix = '    < '                                         " Do not show any separators for virtual text
let g:ale_set_signs = 1
hi ALEVirtualTextError ctermfg=9  guifg=#FF0000
hi ALEVirtualTextWarning ctermfg=33 guifg=#0088FF
hi ALEError ctermfg=9  guifg=#FF0000
hi ALEErrorSign ctermfg=9  guifg=#FF0000
hi ALEWarning ctermfg=226  guifg=#FFFF00
hi ALEWarningSign ctermfg=226  guifg=#FFFF00

" MATCHUP
let g:matchup_matchparen_status_offscreen = 0                                   " Do not show offscreen closing match in statusline
let g:matchup_matchparen_nomode = "ivV\<c-v>"                                   " Enable matchup only in normal mode
let g:matchup_matchparen_deferred = 1                                           " Defer matchup highlights to allow better cursor movement performance

" ANZU
nmap n <Plug>(anzu-n)zz
nmap N <Plug>(anzu-N)zz

" ASTERISK
map * <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)
map # <Plug>(asterisk-z#)<Plug>(anzu-update-search-status)
map g* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)
map g# <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status)

" CTRLSF
let g:ctrlsf_auto_close = 0                                                     " Do not close search when file is opened
let g:ctrlsf_mapping = {'vsplit': 's'}                                          " Mapping for opening search result in vertical split

" RAINBOW
let g:rainbow_active = 1
let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}

" LEXIMA
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_space_rules = 1
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1

" MINPAC
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()

" LANGUAGE-CLIENT
set hidden " Required for operations modifying multiple buffers like rename.
let g:LanguageClient_serverCommands = {
    \ 'java': ['/Users/pwntester/dotfiles/config/lts/jdtls'],
    \ }

" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_loggingFile =  expand('~/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/LanguageServer.log')
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_completionPreferTextEdit = 1

nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
"}}}

