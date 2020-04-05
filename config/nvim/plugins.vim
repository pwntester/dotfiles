" ================ PLUGIN SETUP ======================== {{{
call plug#begin('~/.nvim/plugged') 

    " Github plugins
    Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries' }
    Plug 'Shougo/deoplete.nvim',            { 'do': ':UpdateRemotePlugins'} 
    Plug 'Shougo/deoplete-lsp'
    Plug 'Shougo/neco-vim',
    Plug 'junegunn/fzf.vim' 
    Plug 'pbogut/fzf-mru.vim'
    Plug 'tpope/vim-fugitive' 
    Plug 'andymass/vim-matchup' 
    Plug 'machakann/vim-sandwich'
    Plug 'tomtom/tcomment_vim'
    Plug 'romainl/vim-cool'
    Plug 'Yggdroot/indentLine'
    Plug 'matze/vim-move'
    Plug 'ap/vim-buftabline'
    Plug 'chaoren/vim-wordmotion'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'alvan/vim-closetag'
    Plug 'tommcdo/vim-lion'
    Plug 'tmsvg/pear-tree'
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
    Plug 'neovim/nvim-lsp'
    
    " Local plugins
    Plug '/usr/local/opt/fzf'
    Plug fnameescape(expand('~/Dev/cobange.vim'))
    Plug fnameescape(expand('~/Dev/codeql.nvim'))
    Plug fnameescape(expand('~/Dev/fortify.nvim'))
call plug#end()

" VIM-FORTIFY
execute 'source' fnameescape(expand('~/.config/nvim/fortify.vim'))

" FZF
let g:fzf_layout = { 'window': 'lua require("window").floating_window(false,0.8,0.7)' }
let $FZF_DEFAULT_OPTS='--no-inline-info --layout=reverse --margin=1,2 --color=dark ' .
    \ '--color=fg:#d0d0d0,bg:#020511,hl:#0088ff '.
    \ '--color=fg+:#ffc600,bg+:#020511,hl+:#ffc600 '.
    \ '--color=marker:#3ad900,spinner:#967efb,header:#0088ff '.
    \ '--color=info:#020511,prompt:#0088ff,pointer:#0088ff'

nnoremap <leader>f :call fzf#vim#files('.', {'options': '--prompt ""'})<Return>
nnoremap <leader>h :FZFFreshMru --prompt ""<Return>
nnoremap <leader>c :BCommits<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>o :Buffers<Return>
nnoremap <leader>/ :call fzf#vim#search_history()<Return>
nnoremap <leader>: :call fzf#vim#command_history()<Return>

" INDENTLINE
let g:indentLine_color_gui = '#17252c'
let g:indentLine_fileTypeExclude = g:special_buffers 
let g:indentLine_faster     = 1
let g:indentLine_setConceal = 0

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
let g:rooter_use_lcd = 1
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
let g:polyglot_disabled = ["jsx", "hive"]
let g:no_csv_maps = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']

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

" DEOPLETE
autocmd BufEnter * nested if nvim_buf_line_count(0) < 10000 | call deoplete#enable() | endif
let g:deoplete#enable_at_startup = 0
call deoplete#custom#option({
    \ 'auto_complete_delay': 300,
    \ 'smart_case': v:true,
    \ })

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
let g:plug_window = 'lua require("window").floating_window(true)'
autocmd FileType vim-plug set nocursorline

" VIM-SMOOTHIE
let g:smoothie_no_default_mappings = v:true
nmap <C-d> <Plug>(SmoothieDownwards)
nmap <C-e> <Plug>(SmoothieUpwards)

" VIM-VSNIP
let g:vsnip_snippet_dir = "~/dotfiles/snippets"
imap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

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
    autocmd FileType dirvish :call nvim_win_set_option(0, 'winfixwidth', v:true)

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
        execute "leftabove 30 vsplit | silent Dirvish ".a:1
    else
        execute "leftabove 30 vsplit | silent Dirvish"
    endif
    set winhighlight=EndOfBuffer:EndOfBuffer,SignColumn:Normal,VertSplit:EndOfBuffer,Normal:Normal
endfunction

cnoreabbrev <expr> rm    ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "rm")? ("silent !rm %") : ("rm"))
cnoreabbrev <expr> touch ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "touch")? ("silent !touch %") : ("touch"))
cnoreabbrev <expr> mv    ((nvim_buf_get_option(0, 'filetype') == 'dirvish' && getcmdtype() is# ":" && getcmdline() is# "mv")? ("silent !mv %") : ("mv"))

" VIM-BUFTABLINE
let g:buftabline_show = 1
let g:buftabline_indicators = 1
let g:buftabline_separators = 1

" CODEQL.NVIM
"let g:codeql_search_path = ['~/codeql-home/codeql-repo', '~/codeql-home/pwntester-repo']
let g:codeql_mem_opts = ["--threads", "1", "-J-Xmx8192M", "--off-heap-ram=8192", "-v", "--log-to-stderr"]

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

" LazyGit
nnoremap <Leader>g :echo luaeval("require('window').floating_window(false,0.9,0.9)") <bar> call termopen("lazygit")<Return>
augroup terminal_settings
    autocmd!

    " autocmd BufWinEnter,WinEnter term://* startinsert
    " autocmd BufLeave term://* stopinsert
    autocmd TermOpen term://* startinsert
    autocmd TermClose term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Ignore fzf, ranger, coc
    autocmd TermClose term://*
            \ if (expand('<afile>') !~ "fzf") |
            \   call nvim_input('<CR>')  |
            \ endif
augroup END
" }}}
