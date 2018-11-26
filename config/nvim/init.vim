" ================ PLUGINS ==================== {{{
if &compatible
  set nocompatible
endif

call plug#begin('~/.nvim/plugged')
  Plug '/usr/local/opt/fzf' " Fzf installed with brew
  Plug 'junegunn/fzf.vim'
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
  Plug 'brooth/far.vim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins'}
  Plug 'w0rp/ale'
  Plug 'andymass/vim-matchup'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'airblade/vim-gitgutter'
  Plug 'tomtom/tcomment_vim'
  Plug 'osyo-manga/vim-anzu'
  Plug 'haya14busa/vim-asterisk'
  Plug 'regedarek/ZoomWin'
  Plug 'Yggdroot/indentLine'
  Plug 'matze/vim-move'
  Plug 'pwntester/cobalt2.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
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
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'majutsushi/tagbar'
  Plug 'airblade/vim-rooter'
  Plug 'plasticboy/vim-markdown'
  Plug 'elzr/vim-json'
  Plug 'b4winckler/vim-objc'
  Plug 'kballard/vim-swift'
  Plug 'othree/xml.vim'
  Plug 'derekwyatt/vim-scala'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'tfnico/vim-gradle'
  Plug '~/Development/GitRepos/vim-fortify'
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
set signcolumn=auto                                               " Only sho sign column if there are signs to be shown
set termguicolors
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
silent !mkdir ~/.nvim/backups > /dev/null 2>&1
set undodir=~/.nvim/backups
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
    autocmd FocusGained,BufEnter * checktime
    " spell 
    autocmd FileType markdown nested setlocal spell complete+=kspell
    " enable buffer cycling on non-special buffers
    autocmd BufEnter *.* call BufferSettings()
    " deoplete
    autocmd BufEnter *.* nested if getfsize(@%) > 1000000 | call deoplete#disable() | endif
    " defx
    autocmd FileType defx call DefxSettings()
augroup END

augroup windows
    autocmd!
    " dont show column
    autocmd BufEnter *.* :set colorcolumn=0
    " show cursor line only in active windows
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    " highlight active window
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn=join(range(1, 800), ',')
    autocmd FocusLost,WinLeave * let &l:colorcolumn='+' . join(range(0, 800), ',+')
augroup END
" }}}

" ================ MAPPINGS ==================== {{{
" center after search
nnoremap n nzz
nnoremap N Nzz

" search for visual selection (exact matches, no regexp)
vnoremap // y/\V<C-r>=escape(@",'/\')<Return><Return>

" search for contents of register 0 (where AuditPane copies the RuleIDs)
noremap /0 :execute substitute('/'.@0,'0$','','g')<Return>                                   

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

" disable paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

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

" close window
cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call CloseWin()' : 'q')<Return>
cabbrev wq <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w \| call CloseWin()' : 'wq')<Return>

" save me from 1 files :)
cabbrev w1 <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w!' : 'w1')<Return>
" }}}

" ================ LEADER MAPPINGS ==================== {{{

" space is your leader
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" navigate faster
nnoremap <Leader>j 15j
nnoremap <Leader>k 15k

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
let g:special_buffers = ['help', 'fortifytestpane', 'fortifyauditpane', 'tagbar', 'defx']

function! BufferSettings() abort
    if index(g:special_buffers, &filetype) == -1
        " cycle through buffers
        nnoremap <silent><buffer><S-l> :bnext<Return>
        nnoremap <silent><buffer><S-h> :bprevious<Return>
    endif
endfunction

function! DefxSettings() abort
    nnoremap <silent><buffer><expr> <Return> defx#do_action('open', 'DefxOpenCommand')
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
    nnoremap <silent><buffer> q :call execute("bn\<BAR>bw#")<Return>
    setlocal nobuflisted
endfunction

function! DefxOpen(path)
    let winnrs = range(1, tabpagewinnr(tabpagenr(), '$'))
    if len(winnrs) > 1
        for winnr in winnrs
            if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) == -1
                " found a window with a non-special buffer to open the file to
                execute printf('%swincmd w | drop %s', winnr, a:path)
                return
            endif
        endfor
    endif
    " can't find suitable window, create a new one.
    set splitright
    execute printf('%dvsplit %s', str2nr(&columns) - 50, a:path)
    set splitright&
endfunction

function! FZFOpen(command_str)
    let winnrs = range(1, tabpagewinnr(tabpagenr(), '$')) 
    if len(winnrs) > 1
        for winnr in winnrs
            if index(g:special_buffers, getbufvar(winbufnr(winnr), '&filetype')) > -1 
                " window with a special filetype buffer, we dont want to open the file here
                let next_win = winnr + 1
                execute next_win.'wincmd w'
            else
                " found a window with a non-special buffer to open the file to
                break
            endif
        endfor
    endif
    execute 'normal! ' . a:command_str . "\<cr>"
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

" VIM-MOVE
let g:move_map_keys = 0
vmap ∆ <Plug>MoveBlockDown
vmap ˚ <Plug>MoveBlockUp
nmap ∆ <Plug>MoveLineDown
nmap ˚ <Plug>MoveLineUp

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

" ALE
let g:ale_linters = {}
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.fortifyrulepack = ['ftfylinter']
let g:ale_fixers = {}
let g:ale_fixers.javascript = ['prettier', 'eslint']
let g:ale_linters_explicit = 1                                                  " Only run linters named in ale_linters settings.
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'                                                      " Lint error sign
let g:ale_sign_warning = '⚠'                                                    " Lint warning sign
let g:ale_echo_cursor= 0                                                        " Disble echoing errors in command line
let g:ale_virtualtext_cursor= 1                                                 " Enable virtual text (EOL overlay)
let g:ale_virtualtext_prefix = '    < '                                         " Do not show any separators for virtual text

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

" LEXIMA
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_space_rules = 1
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1
call lexima#add_rule({'char': '-', 'at': '<!-', 'input_after': ' -->', 'filetype': 'fortifyrulepack'})

" MINPAC
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()

" VIM-FORTIFY
execute 'source' fnameescape(expand('~/.config/nvim/fortify.vim'))

" LANGUAGE-CLIENT
set hidden " Required for operations modifying multiple buffers like rename.

let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.java = ['~/dotfiles/config/lts/jdtls']
let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
let g:LanguageClient_serverCommands.python = ['pyls']
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_loggingLevel = 'INFO'

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

" VIM-ROOTER
let g:rooter_use_lcd = 1
let g:rooter_patterns = ['pom.xml', '.git/']
let g:rooter_silent_chdir = 1

" DEFX
nnoremap <silent> <C-e> :Defx -split=vertical -winwidth=50 -toggle<Return>
nnoremap <silent> <C-f> :call execute(printf('Defx -split=vertical -winwidth=50 -toggle %s -search=%s', expand('%:p:h'), expand('%:p')))<Return>
command! -nargs=* -range DefxOpenCommand call DefxOpen(<q-args>)

" COBALT2
set background=dark
colorscheme cobalt2
highlight ALEVirtualTextError ctermfg=9 guifg=#FF0000
highlight ALEVirtualTextWarning ctermfg=33 guifg=#0088FF
highlight ALEError ctermfg=9 guifg=#FF0000
highlight ALEErrorSign ctermfg=9 guifg=#FF0000
highlight ALEWarning ctermfg=33 guifg=#0088FF
highlight ALEWarningSign ctermfg=33 guifg=#0088FF
let g:fzf_colors = {}
let g:fzf_colors.fg = ['fg', 'Normal']
let g:fzf_colors.bg = ['bg', 'Normal']
let g:fzf_colors.hl = ['fg', 'Comment']
let g:fzf_colors['fg+'] = ['fg', 'CursorLine', 'CursorColumn', 'Normal']
let g:fzf_colors['bg+'] = ['bg', 'CursorLine', 'CursorColumn']
let g:fzf_colors['hl+'] = ['fg', 'Statement']
let g:fzf_colors.info = ['fg', 'PreProc']
let g:fzf_colors.prompt = ['fg', 'Conditional']
let g:fzf_colors.pointer = ['fg', 'Exception']
let g:fzf_colors.marker = ['fg', 'Keyword']
let g:fzf_colors.spinner = ['fg', 'Label']
let g:fzf_colors.header = ['fg', 'Comment']

"}}}

