" filetype of defx has not been set when BufWinEnter event is triggered
autocmd FileType defx IndentLinesToggle 
autocmd FileType defx call s:defxSettings()

function! s:openDefx(mode) abort
    " Close it if its open
    for w in nvim_list_wins()
        if nvim_buf_get_option(nvim_win_get_buf(w), 'filetype') == "defx"
            call nvim_win_close(w, v:true)
            return 
        endif
    endfor
    " Open it
    if a:mode == "file"
        call execute(printf('Defx %s -search=%s', expand('%:p:h'), expand('%:p')))
    elseif a:mode == "project"
        call execute('Defx')
    endif
endfunction

function! s:defxSettings() abort
    nnoremap <silent><buffer><expr> <Return> defx#do_action('drop')
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
    nnoremap <silent><buffer><expr> z defx#do_action('resize', winwidth(0))
    setlocal nobuflisted
endfunction

function! Root(path) abort
    return fnamemodify(a:path, ':t') . '/'
endfunction

call defx#custom#source('file', {'root': 'Root'})
call defx#custom#option('_', {
    \ 'columns': 'git:icons:filename:type',
    \ 'split': 'vertical',
    \ 'direction': 'topleft',
    \ 'root_marker': '[in:] ',
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
    \ 'max_width': -90,
\ })

let g:defx_git#indicators = {
  \ 'Modified'  : '+',
  \ 'Staged'    : '●',
  \ 'Untracked' : '?',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Deleted'   : 'x',
  \ 'Unknown'   : '?'
\ }

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

" mappings
nnoremap <silent> <C-f> :call <SID>openDefx("project")<Return>
"nnoremap <silent> <C-e> :call <SID>openDefx("file")<Return>
