if &compatible 
    set nocompatible 
endif

" ================ PLUGINS ==================== {{{

" Disable built-in plugins
let g:loaded_matchit = 1 
let g:loaded_gzip = 1 
let g:loaded_zipPlugin = 1 
let g:loaded_logipat = 1 
let g:loaded_2html_plugin = 1 
let g:loaded_rrhelper = 1 
let g:loaded_getscriptPlugin = 1 
let g:loaded_tarPlugin = 1 
let g:loaded_netrwPlugin = 1

call plug#begin('~/.nvim/plugged') 
    Plug 'pwntester/LanguageClient-neovim', { 'branch': 'alignment', 'do': 'bash install.sh' } 
    Plug 'Shougo/deoplete.nvim',           { 'do': ':UpdateRemotePlugins'} 
    Plug 'Shougo/defx.nvim',               { 'do': ':UpdateRemotePlugins'} 
    Plug 'kristijanhusak/defx-git'
    Plug 'kristijanhusak/defx-icons'
    Plug 'junegunn/fzf.vim' 
    Plug 'pbogut/fzf-mru.vim'
    Plug 'tpope/vim-fugitive' 
    Plug 'jreybert/vimagit'
    Plug 'andymass/vim-matchup' 
    Plug 'Yilin-Yang/vim-markbar'
    Plug 'machakann/vim-sandwich'
    Plug 'tpope/vim-repeat'
    Plug 'airblade/vim-gitgutter'
    Plug 'tomtom/tcomment_vim'
    Plug 'osyo-manga/vim-anzu'
    Plug 'haya14busa/vim-asterisk'
    Plug 'haya14busa/is.vim'
    Plug 'regedarek/ZoomWin'
    Plug 'Yggdroot/indentLine'
    Plug 'matze/vim-move'
    Plug 'pwntester/cobalt2.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'chaoren/vim-wordmotion'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'alvan/vim-closetag'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'cohama/lexima.vim'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'eugen0329/vim-esearch'
    Plug 'AndrewRadev/linediff.vim'
    Plug 'rbgrouleff/bclose.vim'
    Plug 'airblade/vim-rooter'
    Plug 'Konfekt/vim-alias'
    Plug 'kshenoy/vim-signature'
    Plug 'ap/vim-css-color'
    Plug 'sheerun/vim-polyglot'
    
    " Local plugins
    Plug '~/Fortify/SSR/repos/vim-fortify'
    Plug '/usr/local/opt/fzf'
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
" }}}

" ================ UI ==================== {{{
syntax enable
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
set completeopt=noinsert,menuone,noselect                           " show the popup menu even if there's only one match), prevent automatic selection and prevent automatic text injection into the current line.

set shortmess+=c                                                    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
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
    " spell 
    autocmd FileType markdown nested setlocal spell complete+=kspell
    " enable buffer cycling on non-special buffers
    autocmd WinEnter,BufEnter * nested call BufferSettings()
    autocmd WinEnter,BufEnter {} nested call BufferSettings()
    " enable rainbow parenthesis
    autocmd WinEnter,BufEnter * nested call EnableRainbowParenthesis()
    autocmd WinEnter,BufEnter {} nested call EnableRainbowParenthesis()
    " set aliases
    autocmd VimEnter * call SetAliases()
    " deoplete
    autocmd BufEnter * nested if getfsize(@%) < 1000000 | call deoplete#enable() | endif
    " languageclient-neovim
    autocmd BufEnter * nested if getfsize(@%) < 1000000 | call EnableLC() | endif
    " defx
    autocmd FileType defx call DefxSettings()
    " update lightline on LC diagnostic update
    autocmd User LanguageClientDiagnosticsChanged call lightline#update()
    " mark qf as not listed
    autocmd FileType qf setlocal nobuflisted 
    " force write shada on leaving nvim
    autocmd VimLeave * wshada!
augroup END

augroup windows
    autocmd!
    " dont show column
    autocmd BufEnter *.* :set colorcolumn=0
    " show cursor line only in active windows
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " highlight active window
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=CursorLineNr:LineNr,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
    autocmd FocusLost,WinLeave * set winhighlight=
    " prevent opening files on windows with special buffers 
    autocmd BufLeave * call TrackSpecialBuffersOnBufLeave() 
    autocmd BufEnter * call TrackSpecialBuffersOnBufEnter()
augroup END
" }}}

" ================ MAPPINGS ==================== {{{
" center after search
nnoremap n nzz
nnoremap N Nzz

" search for contents of register 0 (where AuditPane copies the RuleIDs)
noremap 0/ :execute substitute('/'.@0,'0$','','g')<Return>                                   

" debug syntax
map <c-g> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<Return>

" escape to normal mode in insert mode
inoremap jk <ESC>

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv

" automatically jump to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" quickly select text you pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" go up/down onw visual line
map j gj
map k gk

" go to eeggining or End of line
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

" jump to last visited location
nnoremap <S-k> <C-^>

" save one keystroke
nnoremap ; :

" resize splits
nnoremap <silent> > :exe "vertical resize +5"<Return>
nnoremap <silent> < :exe "vertical resize -5"<Return>
nnoremap <silent> + :exe "resize +5"<Return>
nnoremap <silent> - :exe "resize -5"<Return>

" }}}

" ================ LEADER MAPPINGS ==================== {{{
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" navigate faster
nnoremap <Leader>j 15j
nnoremap <Leader>k 15k

" paste keeping the default register
vnoremap <Leader>p "_dP

" copy & paste to system clipboard
vmap <Leader>y "*y

" jump to the beggining/end  of changed text
nnoremap <Leader>< `[
nnoremap <Leader>> `]
" }}}

" ================ GLOBALS ======================== {{{
let g:special_buffers = ['help', 'fortifytestpane', 'fortifyauditpane', 'defx', 'qf', 'vim-plug', 'fzf', 'magit']
let g:previous_buffer = 0
let g:is_previous_buffer_special = 0

" ================ FUNCTIONS ======================== {{{
function! SetAliases() abort
    " do not close windows when closing buffers
    Alias bd Bclose

    " close window 
    Alias q call\ CloseWin()<Return>
    Alias q! quit!
    Alias wq write|call\ CloseWin()<Return>
    Alias wq! write|qa!

    " save me from 1 files :)
    Alias w1 w!

    " super save
    Alias W write\ !sudo\ tee\ >\ /dev/null\ %

    " quit all windows
    Alias Q qa!
endfunction

function! BufferSettings() abort
    if index(g:special_buffers, &filetype) == -1
        " cycle through buffers on regular buffers
        nnoremap <silent><buffer><S-l> :bnext<Return>
        nnoremap <silent><buffer><S-h> :bprevious<Return>
    else
        " disable buffer cycling on special buffers
        nnoremap <silent><buffer><S-l> <Nop>
        nnoremap <silent><buffer><S-h> <Nop>
    endif
endfunction

function! TrackSpecialBuffersOnBufLeave() abort
    let bufnum = bufnr('%')
    let g:previous_buffer = bufnum
    if index(g:special_buffers, &filetype) > -1
        let g:is_previous_buffer_special = 1 
        call s:Log('Leaving special buffer '.bufnum)
    else
        let g:is_previous_buffer_special = 0 
        call s:Log('Leaving regular buffer '.bufnum)
    endif
endfunction

function! TrackSpecialBuffersOnBufEnter()
    let bufnum = bufnr('%')
    let bufname = bufname('%')
    let buftype = &filetype

    if index(g:special_buffers, buftype) > -1
        call s:Log('Entering special buffer '.bufnum.' from '.g:previous_buffer)
    else
        call s:Log('Entering regular buffer '.bufnum.' from '.g:previous_buffer)
    endif

    if (bufname == "" && buftype == "") || bufname =~ '^term:'
        " Neither the bufname, mode or type for terminal buffer is set at
        " BufEnter. It is actually set at TermOpen, but that does not work
        " for us. We need to consider that an unnammed buffer is a terminal
        " buffer
        call s:Log('    Skipping unnammed, untyped buffer. FZF buffer?')
        return
    elseif index(g:special_buffers, buftype) > -1 
        call s:Log('    Skipping special buffer')
        return
    elseif g:is_previous_buffer_special && bufexists(g:previous_buffer)
        call s:Log('   Comming from special buffer ' . g:previous_buffer)
        " get special buffer back to this window
        execute 'noautocmd keepalt buffer ' . g:previous_buffer
        " find non-special window
        let winnrs = range(1, tabpagewinnr(tabpagenr(), '$')) 
        if len(winnrs) > 1
            for winnr in winnrs
                if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) == -1
                    " found a window with a non-special buffer
                    " set current window as inactive
                    execute "setlocal nocursorline"
                    execute "set winhighlight="
                    " move to non-special window
                    execute winnr.'wincmd w'
                endif
            endfor
        endif
        " open new buffer
        execute 'noautocmd keepalt buffer ' . bufnum
    elseif g:is_previous_buffer_special && !bufexists(g:previous_buffer)
        call s:Log('    Comming from special buffer (defunct)' . g:previous_buffer)
        " close this window
        try
            silent close! 
        catch
        endtry
        " find non-special window
        let winnrs = range(1, tabpagewinnr(tabpagenr(), '$')) 
        if len(winnrs) > 1
            for winnr in winnrs
                if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) == -1
                    " found a window with a non-special buffer
                    " set current window as inactive
                    execute "setlocal nocursorline"
                    execute "set winhighlight="
                    " move to non-special window
                    execute winnr.'wincmd w'
                endif
            endfor
        endif
        " open new buffer
        execute 'noautocmd keepalt buffer ' . bufnum
    endif
endfunction

function! EnableRainbowParenthesis() abort
    if index(g:special_buffers, &filetype) == -1
        execute 'RainbowParentheses'
    else
        execute 'RainbowParentheses!'
    endif
endfunction

function! Root(path) abort
    return fnamemodify(a:path, ':t') . '/'
endfunction<Paste>

function! DefxSettings() abort
    nnoremap <silent><buffer><expr> <Return> defx#do_action('open')
    nnoremap <silent><buffer><expr> y defx#do_action('copy')
    nnoremap <silent><buffer><expr> m defx#do_action('move')
    nnoremap <silent><buffer><expr> p defx#do_action('paste')
    nnoremap <silent><buffer><expr> N defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> n defx#do_action('new_file')
    nnoremap <silent><buffer><expr> d defx#do_action('remove')
    nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> r defx#do_action('rename')
    nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
    nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> .. defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer> q :call execute("bn\<BAR>bw#")<Return>
    nnoremap <silent><buffer><expr> ~ defx#do_action('change_vim_cwd')
    setlocal nobuflisted
endfunction

function! s:Log(text) abort
    if 0 
        silent execute '!echo '.a:text.' >> /tmp/log'
    endif
endfunction

function! EnableLC() abort
    if index(['java', 'javascript', 'python', 'fortifyrulepack'], &filetype) > -1
        call LanguageClient#startServer()
    endif
endfunction

function! CloseWin()
    if index(g:special_buffers, &filetype) > -1 
        " closing window with special buffer
        quit
    else
        let winnrs = range(1, tabpagewinnr(tabpagenr(), '$')) 
        if len(winnrs) == 1
            " closing window with normal buffer
            quit
        elseif len(winnrs) > 1
            let non_special_buffers_count = 0
            for winnr in winnrs
                if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) == -1 
                    let non_special_buffers_count = non_special_buffers_count + 1
                endif
            endfor
            if non_special_buffers_count == 1
                echo "Last window, not closing"
            else 
                " closing window since there are more non-special windows
                quit
            endif
        endif
    endif
endfunction

function! Refresh_MRU()
  for l:file in fzf_mru#mrufiles#list('raw')
    let l:to_remove = []
    if !filereadable(l:file)
      call add(l:to_remove, l:file)
    endif
    call fzf_mru#mrufiles#remove(l:to_remove)
  endfor
endfunction

" }}}

" ================ PLUGIN SETUP ======================== {{{

" ZOOMWIN
nmap <leader>z <Plug>ZoomWin

" INDENTLINE
let g:indentLine_color_gui = '#17252c'
let g:indentLine_fileTypeExclude = g:special_buffers 

" FZF
let g:fzf_colors = { 
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'ColorColumn'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

nnoremap <leader>f :Files<Return>
nnoremap <leader>h :FZFMru<Return>
nnoremap <leader>c :BCommits<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>d :Buffers<Return>
nnoremap <leader>/ :call fzf#vim#search_history()<Return>
nnoremap <leader>: :call fzf#vim#command_history()<Return>

" VIM-MOVE
" run `cat -v` in terminal and then the <Opt> combos to find out the char to use
let g:move_map_keys = 0
vmap ∆ <Plug>MoveBlockDown
nmap ∆ <Plug>MoveLineDown
vmap ˚ <Plug>MoveBlockUp
nmap ˚ <Plug>MoveLineUp
vmap ˙ <Plug>MoveBlockLeft
nmap ˙ <Plug>MoveBlockLeft
vmap ¬ <Plug>MoveBlockRight
nmap ¬ <Plug>MoveBlockRight

" LIGHTLINE 
execute 'source' fnameescape(expand('~/.config/nvim/lightline.vim'))

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
let g:deoplete#enable_at_startup = 0
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ""
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ">"

" VIM-MARKDOWN
let g:vim_markdown_folding_disabled = 1

" MATCHUP
let g:matchup_matchparen_status_offscreen = 0                                   " Do not show offscreen closing match in statusline
let g:matchup_matchparen_nomode = "ivV\<c-v>"                                   " Enable matchup only in normal mode
let g:matchup_matchparen_deferred = 1                                           " Defer matchup highlights to allow better cursor movement performance

" ANZU / IS.VIM / ASTERISK
let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus=1
map n <Plug>(is-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(is-nohl)<Plug>(anzu-N-with-echo)
map * <Plug>(asterisk-z*)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)
map # <Plug>(asterisk-z#)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)

" ESEARCH
let g:esearch = {}
let g:esearch.adapter = 'rg'
let g:esearch.backend = 'nvim'
let g:esearch.out = 'qflist'
let g:esearch.batch_size = 1000
let g:esearch.use = []
let g:esearch.default_mappings = 0
call esearch#map('r/', 'esearch')
call esearch#map('r*', 'esearch-word-under-cursor')

" LEXIMA
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_space_rules = 1
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1

" VIM-FORTIFY
execute 'source' fnameescape(expand('~/.config/nvim/fortify.vim'))

" LANGUAGE-CLIENT
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.java = ['~/dotfiles/config/lts/jdtls']
let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
let g:LanguageClient_serverCommands.fortifyrulepack = ['~/dotfiles/config/lts/fls']
let g:LanguageClient_serverCommands.python = ['pyls']
call deoplete#custom#source('LanguageClient', 'input_pattern', '.+$')
nnoremap <leader>ld :call LanguageClient#textDocument_definition()<Return>
nnoremap <leader>lr :call LanguageClient#textDocument_rename()<Return>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<Return>
nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<Return>
nnoremap <leader>lx :call LanguageClient#textDocument_references()<Return>
nnoremap <leader>le :call LanguageClient_workspace_applyEdit()<Return>
nnoremap <leader>lc :call LanguageClient#textDocument_completion()<Return>
nnoremap <leader>lh :call LanguageClient#textDocument_hover()<Return>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<Return>
nnoremap <leader>la :call LanguageClient_textDocument_codeAction()<Return>
nnoremap <leader>lm :call LanguageClient_contextMenu()<Return>
let g:LanguageClient_loggingFile = expand('~/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('~/LanguageServer.log')
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_changeThrottle = 1 
let g:LanguageClient_autoStart = 0
let g:LanguageClient_diagnosticsDisplay = { 
            \ 1: {'name': 'Error', 'texthl': 'ALEError', 'signText': 'E', 'signTexthl': 'ALEErrorSign',"virtualTexthl": "ALEVirtualTextError",}, 
            \ 2: {"name": "Warning", "texthl": "ALEWarning", "signText": "W", "signTexthl": "ALEWarningSign","virtualTexthl": "ALEVirtualTextWarning",}, 
            \ 3: {"name": "Information", "texthl": "ALEInfo", "signText": "ℹ", "signTexthl": "ALEInfoSign","virtualTexthl": "ALEVirtualTextWarning",}, 
            \ 4: {"name": "Hint", "texthl": "ALEInfo", "signText": "➤", "signTexthl": "ALEInfoSign","virtualTexthl": "ALEVirtualTextWarning",}, 
    \ }

" VIM-ROOTER
let g:rooter_use_lcd = 1
let g:rooter_patterns = ['pom.xml', '.git/']
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'

" DEFX
nnoremap <silent> <C-e> :Defx<Return>
nnoremap <silent> <C-f> :call execute(printf('Defx %s -search=%s', expand('%:p:h'), expand('%:p')))<Return>
call defx#custom#source('file', {'root': 'Root'})
call defx#custom#option('_', {
    \ 'columns': 'git:icons:filename:type',
    \ 'root_marker': '[in:] ',
    \ 'split': 'vertical',
    \ 'direction': 'topleft',
    \ 'winwidth': 41,
    \ 'show_ignored_files': 1,
    \ 'toggle': 1,
    \ 'listed': 1,
\ })
call defx#custom#column('filename', {
    \ 'directory_icon': ' ',
    \ 'opened_icon': ' ',
    \ 'root_icon': ' ',
    \ 'indent': '  ',
    \ 'min_width': 22,
    \ 'max_width': 22,
\ })

" BCLOSE
let g:bclose_no_plugin_maps = 1

" GITGUTTER 
let g:gitgutter_map_keys = 0

" MARKBAR
nmap <Leader>t <Plug>ToggleMarkbar
let g:markbar_width = 40
let g:markbar_enable_peekaboo = v:false
let g:markbar_marks_to_display = 'abcdefghijklmnopqrstuvwyzABCDEFGHIJKLMNOPQRSTUVWYZ'

" VIMAGIT
let g:magit_auto_foldopen = 0
nnoremap <Leader>r :Magit<Return> 
autocmd User VimagitEnterCommit startinsert

" DEFX-GIT
let g:defx_git#indicators = {
  \ 'Modified'  : '+',
  \ 'Staged'    : '●',
  \ 'Untracked' : '?',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Deleted'   : 'x',
  \ 'Unknown'   : '?'
  \ }

" DEFX-ICONS
let g:defx_icons_exact_matches = {
    \ '.gitconfig': {'icon': '', 'color': '3AFFDB'},
    \ '.gitignore': {'icon':'', 'color': '3AFFDB'},
    \ 'zshrc': {'icon': '', 'color': '3AFFDB'},
    \ '.zshrc': {'icon': '', 'color': '3AFFDB'},
    \ 'zprofile': {'icon':'', 'color': '3AFFDB'},
    \ '.zprofile': {'icon':'', 'color': '3AFFDB'},
    \ }

let g:defx_icon_exact_dir_matches = {
    \ '.git'     : {'icon': '', 'color': '3AFFDB'},
    \ 'Desktop'  : {'icon': '', 'color': '3AFFDB'},
    \ 'Documents': {'icon': '', 'color': '3AFFDB'},
    \ 'Downloads': {'icon': '', 'color': '3AFFDB'},
    \ 'Dropbox'  : {'icon': '', 'color': '3AFFDB'},
    \ 'Music'    : {'icon': '', 'color': '3AFFDB'},
    \ 'Pictures' : {'icon': '', 'color': '3AFFDB'},
    \ 'Public'   : {'icon': '', 'color': '3AFFDB'},
    \ 'Templates': {'icon': '', 'color': '3AFFDB'},
    \ 'Videos'   : {'icon': '', 'color': '3AFFDB'},
    \ }

" }}}

" ================ COLOR SCHEME ======================== {{{
set background=dark
colorscheme cobalt2

hi Defx_filename_root guifg=#668799 ctermfg=66
" hi Defx_filename_directory guifg=#668799 ctermfg=66
hi Directory guifg=#668799 ctermfg=66
"}}}

