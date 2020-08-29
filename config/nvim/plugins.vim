" ================ PLUGIN SETUP ======================== {{{
call plug#begin('~/.nvim/plugged') 

    " Github plugins
    Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries' }
    Plug 'haorenW1025/completion-nvim'
    Plug 'Shougo/neco-vim',
    Plug 'junegunn/fzf.vim' 
    Plug 'pbogut/fzf-mru.vim'
    Plug 'tpope/vim-fugitive' 
    Plug 'andymass/vim-matchup' 
    Plug 'machakann/vim-sandwich'
    Plug 'tomtom/tcomment_vim'
    Plug 'romainl/vim-cool'
    Plug 'Yggdroot/indentLine'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'matze/vim-move'
    Plug 'pacha/vem-tabline'
    Plug 'chaoren/vim-wordmotion'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'alvan/vim-closetag'
    Plug 'tommcdo/vim-lion'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'AndrewRadev/linediff.vim'
    Plug 'airblade/vim-rooter'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'sheerun/vim-polyglot'
    Plug 'psliwka/vim-smoothie'
    Plug 'liuchengxu/vista.vim'
    Plug 'justinmk/vim-dirvish'
    Plug 'lifepillar/vim-colortemplate'
    Plug 'tmsvg/pear-tree'
    Plug 'neovim/nvim-lsp'

    " Notes
    Plug 'ferrine/md-img-paste.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'pbrisbin/vim-mkdir'
    Plug 'jkramer/vim-checkbox', { 'for': 'markdown' }
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    "Plug 'Alok/notational-fzf-vim'

    "Plug 'nvim-treesitter/completion-treesitter'
    "Plug 'nvim-treesitter/nvim-treesitter'

    
    " Local plugins
    Plug '/usr/local/opt/fzf'
    Plug fnameescape(expand('~/Dev/cobange.vim'))
    Plug fnameescape(expand('~/Dev/codeql.nvim'))
    Plug fnameescape(expand('~/Dev/fortify.nvim'))
call plug#end()

" Make colors available to getColorFromHighlight
colorscheme cobange
let cobalt1_color = GetColorFromHighlight('Normal', 'bg')
let cobalt2_color = GetColorFromHighlight('EndOfBuffer', 'fg')
let blue_color = GetColorFromHighlight('Comment', 'fg')
let yellow_color = GetColorFromHighlight('Function', 'fg')
let green_color = GetColorFromHighlight('Title', 'fg')
let grey_color = GetColorFromHighlight('PMenu', 'fg')
let orange_color = GetColorFromHighlight('Identifier', 'fg')

" VIM-FORTIFY
execute 'source' fnameescape(expand('~/.config/nvim/fortify.vim'))

" FZF
let g:fzf_layout = { 'window': 'lua require("window").floating_window(true,0.7,0.7)' }
let $FZF_DEFAULT_OPTS='--no-inline-info --layout=reverse --margin=0,0 --color=dark '.
    \ '--color=fg:'.grey_color.',bg:'.cobalt1_color.',hl:'.blue_color.' '.
    \ '--color=fg+:'.yellow_color.',bg+:'.cobalt1_color.',hl+:'.yellow_color.' '.
    \ '--color=marker:'.green_color.',spinner:'.orange_color.',header:'.blue_color.' '.
    \ '--color=info:'.cobalt1_color.',prompt:'.blue_color.',pointer:'.blue_color

nnoremap <leader>f :call fzf#vim#files('.', {'options': '--prompt ""'})<Return>
nnoremap <leader>m :FZFFreshMru --prompt ""<Return>
nnoremap <leader>c :BCommits<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>o :Buffers<Return>
nnoremap <leader>/ :call fzf#vim#search_history()<Return>
nnoremap <leader>: :call fzf#vim#command_history()<Return>

" INDENTLINE
let g:indentLine_color_gui = cobalt2_color
let g:indentLine_fileTypeExclude = g:special_buffers + ['markdown']
let g:indentLine_faster = 1
let g:indentLine_conceallevel = 2

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

" VIM-WORDMOTION
let g:wordmotion_prefix = '<Leader>'

" VIM-CLOSETAG
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsp'
let g:closetag_filetypes = 'html,xhtml,phtml,fortifyrulepack,xml,jsp'
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsp,*.html'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,fortifyrulepack'

" MATCHUP
let g:matchup_matchparen_status_offscreen = 0                            " Do not show offscreen closing match in statusline
let g:matchup_matchparen_nomode = "ivV\<c-v>"                            " Enable matchup only in normal mode
let g:matchup_matchparen_deferred = 1                                    " Defer matchup highlights to allow better cursor movement performance

" PEAR-TREE
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1

" VIM-ROOTER
let g:rooter_cd_cmd = "lcd" 
let g:rooter_patterns = ['.git/'] "['build.gradle', 'build.sbt', 'pom.xml', '.git/']
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'

" GITGUTTER 
let g:gitgutter_map_keys = 0

" VIM-GO
function! ReuseVimGoTerm(cmd) abort
  for w in nvim_list_wins()
    if "goterm" == nvim_buf_get_option(nvim_win_get_buf(w), 'filetype')
      call nvim_win_close(w, v:true)
      break
    endif
  endfor
  execute a:cmd
endfunction
let g:go_gopls_enabled = 0
let g:go_term_enabled = 1
let g:go_term_mode = "silent keepalt rightbelow 15 split"
let g:go_def_reuse_buffer = 1
let g:go_def_mapping_enabled = 0
let g:go_fold_enable = []
let g:go_code_completion_enabled = 0
let g:go_textobj_enabled = 0
let g:go_echo_command_info = 0
let g:go_highlight_diagnostic_errors = 0
let g:go_highlight_diagnostic_warnings = 0
autocmd FileType go nmap <buffer> <leader>r :call ReuseVimGoTerm('GoRun')<Return>

" VIM-POLYGLOT
let g:polyglot_disabled = ["jsx", "hive", "markdown"]
let g:no_csv_maps = 1

" VIM-MARKDOWN
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = [
    \ 'csharp=cs', 
    \ 'c++=cpp', 
    \ 'viml=vim', 
    \ 'bash=sh', 
    \ 'ini=dosini', 
    \ 'java', 
    \ 'ql'
\ ]
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_new_list_item_indent = 0 
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_autowrite = 1

" VIM-LION
let g:lion_squeeze_spaces = 1 " align around a given char: gl<character>

" RAINBOW-PARENTHESES
autocmd WinEnter,BufEnter * nested call s:enableRainbowParentheses()
autocmd WinEnter,BufEnter {} nested call s:enableRainbowParentheses()
function! s:enableRainbowParentheses() abort
    if index(g:special_buffers, &filetype) == -1 && exists(":RainbowParentheses")
        " Activate
        silent execute "RainbowParentheses"
    elseif exists(":RainbowParentheses")
        " Deactivate
        silent execute "RainbowParentheses!"
    endif
endfunction

" VISTA
let g:vista_default_executive = 'nvim_lsp'
let g:vista_sidebar_position = 'vertical topleft 15'
let g:vista_fzf_preview = ['right:50%']
let g:vista_keep_fzf_colors = 1
nmap <leader>v :Vista<Return>
nmap <leader>vf :Vista finder<Return>

" COLORIZER
lua require('colorizer').setup()

" VIM-PLUG
let g:plug_window = 'lua require("window").floating_window(true,0.8,0.8)'
autocmd FileType vim-plug set nocursorline

" VIM-SMOOTHIE
let g:smoothie_no_default_mappings = v:true
nmap <C-d> <Plug>(SmoothieDownwards)
nmap <C-e> <Plug>(SmoothieUpwards)

" VIM-DIRVISH
call sign_define("indent", {"text": " "})
let g:dirvish_mode = ':sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _'
nnoremap ge :call ToggleDirvish()<Return>
nnoremap gf :call ToggleDirvish('%')<Return>
augroup dirvish_config
    autocmd!

    " indent text by adding a transparent sign
    autocmd FileType dirvish call nvim_buf_set_lines(0, 0, 0, 0, [expand('%')."../"])

    " indent text by adding a transparent sign
    autocmd FileType dirvish sign place 1 line=1 name=indent

    " map `<CR>` to open in previous window.
    autocmd FileType dirvish nnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? 
        \ ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish()<Return>"
    autocmd FileType dirvish xnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? 
        \ ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish()<Return>"

    " map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
    autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

    " reload dirvish after shell commands
    autocmd ShellCmdPost * if nvim_buf_get_option(0, 'filetype') == 'dirvish' | Dirvish % | endif

    " fix dirvish win width
    autocmd FileType dirvish call nvim_win_set_option(0, 'winfixwidth', v:true)

    " status line
    autocmd FileType dirvish call StatusLine()

    " map .. to -
    autocmd FileType dirvish nnoremap <silent><buffer> .. :Dirvish ..<CR>
augroup END

function ToggleDirvish(...)
    for w in nvim_list_wins()
        let bufnr = nvim_win_get_buf(w)
        if nvim_buf_get_option(bufnr, "filetype") == "dirvish"
            call nvim_win_close(w, 1)
            return
        endif
    endfor
    if a:0 > 0
        if a:1 == "%"
            execute "leftabove 30 vsplit | silent Dirvish ".getreg("%")
        else
            execute "leftabove 30 vsplit | silent Dirvish ".a:1
        endif
    else
        execute "leftabove 30 vsplit | silent Dirvish"
    endif
    set winhighlight=EndOfBuffer:EndOfBuffer,SignColumn:Normal,VertSplit:EndOfBuffer,Normal:Normal
endfunction

cnoreabbrev <expr> rm    ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "rm")? ("silent !rm %") : ("rm"))
cnoreabbrev <expr> touch ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "touch")? ("silent !touch %") : ("touch"))
cnoreabbrev <expr> mv    ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "mv")? ("silent !mv %") : ("mv"))

" CODEQL.NVIM
let g:codeql_max_ram = 32000
let g:codeql_search_path = '/Users/pwntester/codeql-home/codeql-repo'

" NVIM-LSP
let g:LspDiagnosticsErrorSign = 'x'
let g:LspDiagnosticsWarningSign = 'w'
let g:LspDiagnosticsInformationSign = 'i'
let g:LspDiagnosticsHintSign = 'h'

lua require("lsp-config").setup()
let g:nvim_lsp_code_action_menu = 'FZFCodeActionMenu'
function! FZFCodeActionMenu(actions, callback) abort
    call fzf#run(fzf#wrap({
        \ 'source': map(deepcopy(a:actions), {idx, item -> string(idx).'::'.item.title}),
        \ 'sink': function('ApplyAction', [a:callback]),
        \ 'options': '+m --with-nth 2.. -d "::"',
        \ }))
endfunction
function! ApplyAction(callback, chosen) abort
    let l:idx = split(a:chosen, '::')[0] + 1
    execute 'call '.a:callback.'('.l:idx.')'
endfunction
autocmd User LspDiagnosticsChanged call StatusLine()

" JAVA
let g:java_highlight_all = 1
let g:java_space_errors = 1
let g:java_comment_strings = 1
let g:java_highlight_functions = 1
let g:java_highlight_debug = 1 
let g:java_mark_braces_in_parens_as_errors = 1

" LAZYGIT 
nnoremap <Leader>g :echo luaeval("require('window').floating_window(false,0.9,0.9)") <bar> call termopen("lazygit")<Return>

" VIM-VSNIP
let g:vsnip_snippet_dir = "~/dotfiles/snippets"
imap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

" MD-IMG-PASTE
nnoremap <leader>p :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = 'images'

" GOYO
nnoremap <leader>y :Goyo<CR>
inoremap <leader>y :Goyo<CR>

function! s:goyo_enter()
    highlight NormalNC guifg=#FFFFFF guibg=#101a20
endfunction

function! s:goyo_leave()
    highlight NormalNC guifg=#FFFFFF guibg=#1b2b34
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" VEM-Tabline 
nmap <S-h> <Plug>vem_prev_buffer-
nmap <S-l> <Plug>vem_next_buffer-
nmap <leader>h <Plug>vem_move_buffer_left-
nmap <leader>l <Plug>vem_move_buffer_right-
function! DeleteCurrentBuffer() abort
    let current_buffer = bufnr('%')
    let next_buffer = g:vem_tabline#tabline.get_replacement_buffer()
    try
        exec 'confirm ' . current_buffer . 'bdelete'
        if next_buffer != 0
            exec next_buffer . 'buffer'
        endif
    catch /E516:/
       " If the operation is cancelled, do nothing
    endtry
endfunction

" NOTATIONAL-FZF-VIM
" let g:nv_search_paths = ['~/bitacora']
" nnoremap <leader>e :NV<CR>

" SNIPPET.NVIM
" lua require("snippets-config")
" inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>
" inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>

" TREESITTER
"lua require('treesitter').setup()

