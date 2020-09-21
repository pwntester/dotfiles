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
set shiftwidth=4                                                  " Reduntant with above
set tabstop=4                                                     " How many spaces on tab
set softtabstop=4                                                 " One tab = 4 spaces
set expandtab                                                     " Tabs are spaces
set smartindent                                                   " Smart ident
set shiftround                                                    " Round indent to multiple of 'shiftwidth'
set showtabline=2
set laststatus=2
set number
set norelativenumber
set keywordprg=:help                                         " Press K to show help for word under cursor
set conceallevel=2
set concealcursor=nc
set wildmode=longest,full                                         "stuff to ignore when tab completing
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
set ignorecase                                                 " Disable case-sensitive searches (override with \c or \C)
set smartcase                                                  " If the search term contains uppercase letters, do case-sensitive search
" }}}

" ================ INIT.LUA ======================== {{{
lua dofile(vim.api.nvim_get_runtime_file("lua/init.lua", 0)[1])

" }}}

