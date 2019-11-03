"let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
"let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4'
"let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(10)
  let width = float2nr(80)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 1

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

function! s:pick(jump, item) abort
    let idx = split(a:item, ' ')[0]
    execute a:jump idx + 1
endfunction

function! s:fuzzyPick(items, jump) abort
  let items = map(a:items, {idx, item -> string(idx).' '.bufname(item.bufnr).' '.item.text})
  call fzf#run({
    \ 'source': items,
    \ 'sink': function('Pick', [a:jump]),
    \ 'down': '~20%',
    \ 'options': '--with-nth 2.. +s -e --ansi', 
    \ })
endfunction

function! s:fzf_quickfix_list() abort
    call s:fuzzyPick(getqflist(), 'cc')
endfunction

function! s:fzf_location_list() abort
    call s:fuzzyPick(getloclist(0), 'll')
endfunction

function! s:fzf_nst_files()
    let buffer_path = resolve(expand('%:p'))
    let pattern = buffer_path . '.nst'
    if exists("g:fortify_NSTRoot") && g:fortify_NSTRoot != ""
        let home = g:fortify_NSTRoot
    else 
        let home = glob('~')
    endif
    if exists("g:fortify_SCAVersion") && g:fortify_SCAVersion != ""
        let sca_version = 'sca'. string(g:fortify_SCAVersion)
    else
        call GetSCAVersion()
        let sca_version = 'sca'. string(g:fortify_SCAVersion)
    endif
    let root = home . '/.fortify/' . sca_version . '/build'
    let command = 'rg --files -g "**' . pattern . '" ' . root
    call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'down': '~20%',
        \ 'options': '+s -e --ansi',
        \ })
endfunction

function! s:fzf_rulepack_files()
    let command = 'rg --files -g "**/src/*.xml" /Users/alvaro/Fortify/SSR/repos/rules'
    call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'down': '~20%',
        \ 'options': '+s -e --ansi',
        \ })
endfunction

function! s:fzf_rulepack_descriptions()
    let command = 'rg --files -g "**/descriptions/en/*.xml" /Users/alvaro/Fortify/SSR/repos/rules'
    call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'down': '~20%',
        \ 'options': '+s -e --ansi',
        \ })
endfunction

let g:fzf_colors =
    \ { 'fg':      ['fg', 'FZF_fg'],
      \ 'bg':      ['bg', 'FZF_bg'],
      \ 'hl':      ['fg', 'FZF_fg_matched'],
      \ 'fg+':     ['fg', 'FZF_fg_current', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'FZF_bg_current', 'CursorColumn' ],
      \ 'hl+':     ['fg', 'FZF_fg_matched'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

nnoremap <leader>n :call <SID>fzf_nst_files()<Return>
nnoremap <leader>r :call <SID>fzf_rulepack_files()<Return>
nnoremap <leader>d :call <SID>fzf_rulepack_descriptions()<Return>
nnoremap <leader>l :call <SID>fzf_location_list()<Return>
nnoremap <leader>q :call <SID>fzf_quickfix_list()<Return>
"nnoremap <leader>f :Files<Return>
nnoremap <leader>f :call fzf#vim#files('.', {'options': '--prompt ""'})<Return>
nnoremap <leader>h :FZFFreshMru<Return>
nnoremap <leader>c :BCommits<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>b :Buffers<Return>
nnoremap <leader>/ :call fzf#vim#search_history()<Return>
nnoremap <leader>: :call fzf#vim#command_history()<Return>

" hide status bar
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
