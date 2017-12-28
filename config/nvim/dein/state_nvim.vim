let [plugins, ftplugin] = dein#load_cache_raw(['/Users/alvaro/.config/nvim/init.vim', '/Users/alvaro/.config/nvim/rc.d/dein.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/alvaro/.config/nvim/dein'
let g:dein#_runtime_path = '/Users/alvaro/.config/nvim/dein/.cache/init.vim/.dein'
let g:dein#_cache_path = '/Users/alvaro/.config/nvim/dein/.cache/init.vim'
let &runtimepath = '/Users/alvaro/.config/nvim,/etc/xdg/nvim,/Users/alvaro/.local/share/nvim/site,/usr/local/share/nvim/site,/Users/alvaro/.config/nvim/dein/repos/github.com/junegunn/fzf,/Users/alvaro/.config/nvim/dein/.cache/init.vim/.dein,/usr/share/nvim/site,/usr/local/Cellar/neovim/0.2.2/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/alvaro/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/alvaro/.config/nvim/after,/Users/alvaro/.config/nvim/dein/repos/github.com/Shougo/dein.vim,/Users/alvaro/.config/nvim/dein/.cache/init.vim/.dein/after'
filetype off
silent! nnoremap <unique><silent> <Plug>(choosewin :call dein#autoload#_on_map('<lt>Plug>(choosewin', 'vim-choosewin','n')<CR>
silent! xnoremap <unique><silent> <Plug>(choosewin :call dein#autoload#_on_map('<lt>Plug>(choosewin', 'vim-choosewin','x')<CR>
silent! onoremap <unique><silent> <Plug>(choosewin :call dein#autoload#_on_map('<lt>Plug>(choosewin', 'vim-choosewin','o')<CR>
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Linediff call dein#autoload#_on_cmd('Linediff', 'linediff.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Far call dein#autoload#_on_cmd('Far', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Fardo call dein#autoload#_on_cmd('Fardo', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Farp call dein#autoload#_on_cmd('Farp', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Refar call dein#autoload#_on_cmd('Refar', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Farundo call dein#autoload#_on_cmd('Farundo', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* F call dein#autoload#_on_cmd('F', 'far.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* ZoomWin call dein#autoload#_on_cmd('ZoomWin', 'ZoomWin', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Delete call dein#autoload#_on_cmd('Delete', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Unlink call dein#autoload#_on_cmd('Unlink', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Move call dein#autoload#_on_cmd('Move', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Rename call dein#autoload#_on_cmd('Rename', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Chmod call dein#autoload#_on_cmd('Chmod', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Mkdir call dein#autoload#_on_cmd('Mkdir', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Find call dein#autoload#_on_cmd('Find', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Locate call dein#autoload#_on_cmd('Locate', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Wall call dein#autoload#_on_cmd('Wall', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* SudoWrite call dein#autoload#_on_cmd('SudoWrite', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* SudoEdit call dein#autoload#_on_cmd('SudoEdit', 'vim-eunuch', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
silent! command -complete=customlist,dein#autoload#_dummy_complete -bang -bar -range -nargs=* Dein call dein#autoload#_on_cmd('Dein', 'dein-command.vim', <q-args>,  expand('<bang>'), expand('<line1>'), expand('<line2>'))
nnoremap <leader>m :History<Return>
nnoremap <leader>b :Buffers<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>d :Files<Return>
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_colors = { 'fg':      ['fg', 'Normal'], 'bg':      ['bg', 'Normal'], 'hl':      ['fg', 'Comment'], 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+':     ['bg', 'CursorLine', 'CursorColumn'], 'hl+':     ['fg', 'Statement'], 'info':    ['fg', 'PreProc'], 'prompt':  ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] }
autocmd BufNewFile,BufRead *.gradle nested set filetype=groovy 
if exists('+colorcolumn')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn=join(range(1, 800), ',')
    autocmd FocusLost,WinLeave * let &l:colorcolumn='+' . join(range(0, 800), ',+')
endif
set background=dark
colorscheme cobalt2
highlight ColorColumn guibg=#020511
highlight Normal guibg=#17252c
highlight Search  gui=underline guifg=red guibg=#020511
highlight EndOfBuffer guibg=#17252c guifg=#17252c
execute 'source' fnameescape(expand('~/.config/nvim/rc.d/lightline.vim'))
autocmd BufEnter * nested Neomake
autocmd BufWritePost * nested Neomake
autocmd User NeomakeFinished nested call lightline#update()
let g:neomake_javascript_enabled_checkers = ['jshint', 'eslint']
let g:neomake_javascript_eslint_marker = {   'exe': 'eslint_d',   'args': ['-f', 'compact', '--fix'],   'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .   '%W%f: line %l\, col %c\, Warning - %m' }
if has('macunix')
    let g:neomake_swift_enabled_makers = ['swiftc']
    let g:neomake_swift_swiftc_maker = { 'args': ['-parse','-target', 'x86_64-apple-ios10.0','-sdk', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk' ], 'errorformat': '%E%f:%l:%c: error: %m,' . '%W%f:%l:%c: warning: %m,' . '%Z%\s%#^~%#,' . '%-G%.%#', }
    let g:neomake_objc_enabled_makers = ['clang']
    let g:neomake_objc_clang_maker = { 'args': [ '-fsyntax-only', '-Wall', '-Wextra', '-c', '-mios-simulator-version-min=10.0', '-fobjc-abi-version=2', '-isysroot', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk',], 'errorformat': '%-G%f:%s:,' . '%f:%l:%c: %trror: %m,' . '%f:%l:%c: %tarning: %m,' . '%f:%l:%c: %m,'. '%f:%l: %trror: %m,'. '%f:%l: %tarning: %m,'. '%f:%l: %m', }
endif
let g:neomake_error_sign = { 'text': '✖', 'texthl': 'NeomakeErrorMsg', }
let g:neomake_warning_sign = { 'text': '⚠', 'texthl': 'NeomakeWarningMsg', }
nnoremap <leader>i :NewRuleID<Return>
let g:fortify_SCAPath = "/Applications/HP_Fortify/sca"
let g:fortify_PythonPath = "/usr/local/lib/python2.7/site-packages"
let g:fortify_AndroidJarPath = "/Users/alvaro/Library/Android/sdk/platforms/android-22/android.jar"
let g:fortify_DefaultJarPath = "/Applications/HP_Fortify/default_jars" 
let g:fortify_MemoryOpts = [ "-Xmx4096M", "-Xss24M", "-64" ]
let g:fortify_AWBOpts = []
let g:fortify_ScanOpts = [ "-Dcom.fortify.sca.limiters.MaxPassthroughChainDepth=4", "-Dcom.fortify.sca.limiters.MaxChainDepth=5", "-Dcom.fortify.sca.DebugNumericTaint=true", "-Dcom.fortify.sca.ReportTrippedDepthLimiters=true", "-Dcom.fortify.sca.ReportTrippedNodeLimiters=true", "-Dcom.fortify.sca.ReportTightenedLimits=true",  "-Dcom.fortify.sca.alias.mode.scala=fi", ]
let g:fortify_TranslationOpts = []
let g:fortify_JDKVersion = "1.8"
let g:fortify_XCodeSDK = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
autocmd BufNewFile,BufReadPost *.xml nested map R ,R
autocmd BufNewFile,BufReadPost *.rules nested map R ,R
autocmd BufNewFile,BufReadPost *.xml nested map r ,r
autocmd BufNewFile,BufReadPost *.rules nested map r ,r
autocmd FileType fortifydescription nested setlocal spell complete+=kspell
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
nmap <C-w><C-w> <Plug>(choosewin)
autocmd BufNewFile,BufRead *.m nested set filetype=objc
let g:move_map_keys = 0
vmap ∆ <Plug>MoveBlockDown
vmap ˚ <Plug>MoveBlockUp
nmap ∆ <Plug>MoveLineDown
nmap ˚ <Plug>MoveLineUp
let g:wordmotion_prefix = '<Leader>'
nnoremap <leader>c :call deoplete#toggle()<Cr>
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : ""
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : ">"
let g:far#default_mappings = 0
augroup FARBufferEnter
    autocmd FileType far_vim nnoremap <buffer><silent> x :call g:far#change_exclude_under_cursor(1)<cr>
    autocmd FileType far_vim vnoremap <buffer><silent> x :call g:far#change_exclude_under_cursor(1)<cr>
    autocmd FileType far_vim nnoremap <buffer><silent> i :call g:far#change_exclude_under_cursor(0)<cr>
    autocmd FileType far_vim vnoremap <buffer><silent> i :call g:far#change_exclude_under_cursor(0)<cr>
    autocmd FileType far_vim nnoremap <buffer><silent> t :call g:far#change_exclude_under_cursor(-1)<cr>
    autocmd FileType far_vim vnoremap <buffer><silent> t :call g:far#change_exclude_under_cursor(-1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> X :call g:far#change_exclude_all(1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> I :call g:far#change_exclude_all(0)<cr>
    autocmd FileType far_vim noremap <buffer><silent> T :call g:far#change_exclude_all(-1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> <CR> :call g:far#jump_buffer_under_cursor()<cr>
    autocmd FileType far_vim noremap <buffer><silent> p :call g:far#show_preview_window_under_cursor()<cr>
    autocmd FileType far_vim noremap <buffer><silent> P :call g:far#close_preview_window()<cr>
    autocmd FileType far_vim noremap <buffer><silent> u :call g:far#scroll_preview_window(-g:far#preview_window_scroll_step)<cr>
    autocmd FileType far_vim noremap <buffer><silent> d :call g:far#scroll_preview_window(g:far#preview_window_scroll_step)<cr>
    autocmd FileType far_vim noremap <buffer><silent> zo :call g:far#change_collapse_under_cursor(0)<cr>
    autocmd FileType far_vim noremap <buffer><silent> zc :call g:far#change_collapse_under_cursor(1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> za :call g:far#change_collapse_under_cursor(-1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> zO :call g:far#change_collapse_all(0)<cr>
    autocmd FileType far_vim noremap <buffer><silent> zC :call g:far#change_collapse_all(1)<cr>
    autocmd FileType far_vim noremap <buffer><silent> zT :call g:far#change_collapse_all(-1)<cr>
augroup END
nmap <leader>z <Plug>ZoomWin
let g:vim_markdown_folding_disabled = 1
autocmd FileType markdown nested setlocal spell complete+=kspell
let g:indentLine_color_gui = '#17252c'
let g:indentLine_fileTypeExclude = ['fortifytestpane', 'fortifyauditpane']
autocmd dein-events InsertEnter * call dein#autoload#_on_event("InsertEnter", ['lexima.vim', 'ultisnips', 'vim-snippets', 'deoplete.nvim'])
