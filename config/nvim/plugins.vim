" ================ PLUGIN SETUP ======================== {{{
call plug#begin('~/.nvim/plugged') 
    " Github plugins
    Plug 'Shougo/deoplete.nvim',            { 'do': ':UpdateRemotePlugins'} 
    Plug 'Shougo/defx.nvim',                { 'do': ':UpdateRemotePlugins'} 
    Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries' }
    "Plug 'natebosch/vim-lsc'
    Plug 'pwntester/vim-lsc'
    Plug 'hrsh7th/deoplete-vim-lsc'
    Plug 'kristijanhusak/defx-git'
    Plug 'kristijanhusak/defx-icons'
    Plug 'rhysd/git-messenger.vim'
    Plug 'junegunn/fzf.vim' 
    Plug 'pbogut/fzf-mru.vim'
    Plug 'tpope/vim-fugitive' 
    Plug 'jreybert/vimagit'
    Plug 'andymass/vim-matchup' 
    Plug 'machakann/vim-sandwich'
    Plug 'tpope/vim-repeat'
    Plug 'airblade/vim-gitgutter'
    Plug 'tomtom/tcomment_vim'
    Plug 'osyo-manga/vim-anzu'
    Plug 'haya14busa/vim-asterisk'
    Plug 'haya14busa/is.vim'
    Plug 'Yggdroot/indentLine'
    Plug 'matze/vim-move'
    Plug 'pwntester/cobalt2.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'chaoren/vim-wordmotion'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'alvan/vim-closetag'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'schickling/vim-bufonly'
    Plug 'tommcdo/vim-lion'
    Plug 'tmsvg/pear-tree'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'AndrewRadev/linediff.vim'
    Plug 'rbgrouleff/bclose.vim'
    Plug 'airblade/vim-rooter'
    Plug 'Konfekt/vim-alias'
    Plug 'kshenoy/vim-signature'
    Plug 'ap/vim-css-color'
    Plug 'sheerun/vim-polyglot'
    Plug 'wellle/targets.vim'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'CoatiSoftware/vim-sourcetrail'
    Plug 'liuchengxu/vista.vim'
    
    " Local plugins
    Plug '/usr/local/opt/fzf'
    if isdirectory(fnameescape(expand('~/Fortify/SSR/repos/vim-fortify')))
        Plug fnameescape(expand('~/Fortify/SSR/repos/vim-fortify'))
    elseif isdirectory(fnameescape(expand('~/Dev/vim-fortify')))
        Plug fnameescape(expand('~/Dev/vim-fortify'))
    endif
call plug#end()

" VIM-FORTIFY
execute 'source' fnameescape(expand('~/.config/nvim/fortify.vim'))

" FZF
execute 'source' fnameescape(expand('~/.config/nvim/fzf.vim'))

" LIGHTLINE 
execute 'source' fnameescape(expand('~/.config/nvim/lightline.vim'))

" DEFX
execute 'source' fnameescape(expand('~/.config/nvim/defx.vim'))

" VIM-LSC
execute 'source' fnameescape(expand('~/.config/nvim/lsc.vim'))

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

" ULTISNIPS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

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

" PEAR-TREE
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1

" VIM-ROOTER
let g:rooter_use_lcd = 1
let g:rooter_patterns = ['build.gradle', 'build.sbt', 'pom.xml', '.git/']
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'

" BCLOSE
let g:bclose_no_plugin_maps = 1

" GITGUTTER 
let g:gitgutter_map_keys = 0

" VIMAGIT
let g:magit_auto_foldopen = 0
nnoremap <Leader>g :Magit<Return> 
autocmd User VimagitEnterCommit startinsert

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

let g:go_term_enabled = 1
let g:go_term_mode = "silent keepalt rightbelow 15 split"
let g:go_def_reuse_buffer = 1

autocmd FileType go nmap <leader>r :call ReuseVimGoTerm('GoRun')<Return>

" VIM-POLYGLOT
let g:polyglot_disabled = ["jsx"]

" VIM-LION
" align around a given char: gl<character>
let g:lion_squeeze_spaces = 1

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

" VIM-ALIAS
function! CloseWin()
    if index(g:special_buffers, &filetype) > -1 
        " closing window with special buffer
        quit
    else
        let l:current_window = win_getid()
        let l:winids = nvim_list_wins()
        if len(l:winids) == 1
            " closing window with normal buffer
            quit
        elseif len(winids) > 1
            let l:non_special_buffers_count = 0
            for w in l:winids
                if index(g:special_buffers, nvim_buf_get_option(nvim_win_get_buf(w), 'filetype')) == -1 
                    let l:non_special_buffers_count = l:non_special_buffers_count + 1
                endif
            endfor
            if l:non_special_buffers_count == 1
                " only one normal window, but some special ones opened
                quitall
            else 
                " closing window since there are more non-special windows
                call nvim_win_close(l:current_window, v:true)
            endif
        endif
    endif
endfunction
function! SetAliases() abort
    " do not close windows when closing buffers
    Alias bd Bclose
    Alias bo BufOnly

    " close window 
    Alias q call\ CloseWin()<Return>
    Alias q! quit!
    Alias wq write|call\ CloseWin()<Return>
    Alias wq! write|qa!
    Alias Q quitall!

    " save me from 1 files :)
    Alias w1 w!

    " super save
    Alias W write\ !sudo\ tee\ >\ /dev/null\ %
endfunction
autocmd VimEnter * call SetAliases()

" DEOPLETE
autocmd BufEnter * nested if getfsize(@%) < 1000000 | call deoplete#enable() | endif
let g:deoplete#enable_at_startup = 0
inoremap <expr> <Return> (pumvisible() ? "\<c-y>\<cr>" : "\<Return>")
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ""
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ">"

" GIT-MESSANGER
nmap <Leader>gm <Plug>(git-messenger)

" VISTA
let g:vista_default_executive = 'vim_lsc'
let g:vista_fzf_preview = ['right:50%']
nmap <leader>v :Vista<Return>
nmap <leader>vf :Vista finder<Return>

" }}}

