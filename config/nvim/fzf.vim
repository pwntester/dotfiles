lua require("navigation")
let g:fzf_layout = { 'window': 'lua FloatingWin()' }

let $FZF_DEFAULT_OPTS='--no-inline-info --layout=reverse --margin=1,2 --color=dark ' .
    \ '--color=fg:#d0d0d0,bg:#020511,hl:#0088ff '.
    \ '--color=fg+:#ffc600,bg+:#020511,hl+:#ffc600 '.
    \ '--color=marker:#3ad900,spinner:#967efb,header:#0088ff '.
    \ '--color=info:#020511,prompt:#0088ff,pointer:#0088ff'

function! s:pick(jump, item) abort
    let idx = split(a:item, ' ')[0]
    execute a:jump idx + 1
endfunction

function! s:fuzzyPick(items, jump) abort
  let items = map(a:items, {idx, item -> string(idx).' '.bufname(item.bufnr).' '.item.text})
  call fzf#run(fzf#wrap({
    \ 'source': items,
    \ 'sink': function('<SID>pick', [a:jump]),
    \ 'options': '--with-nth 2.. +s -e --ansi --prompt ""', 
    \ }))
endfunction

function! s:fzf_quickfix_list() abort
    call s:fuzzyPick(getqflist(), 'cc')
endfunction

function! s:fzf_location_list() abort
    call s:fuzzyPick(getloclist(0), 'll')
endfunction

"nnoremap <leader>l :call <SID>fzf_location_list()<Return>
nnoremap <leader>q :call <SID>fzf_quickfix_list()<Return>
nnoremap <leader>f :call fzf#vim#files('.', {'options': '--prompt ""'})<Return>
nnoremap <leader>h :FZFFreshMru --prompt ""<Return>
nnoremap <leader>c :BCommits<Return>
nnoremap <leader>s :Snippets<Return>
nnoremap <leader>o :Buffers<Return>
nnoremap <leader>/ :call fzf#vim#search_history()<Return>
nnoremap <leader>: :call fzf#vim#command_history()<Return>

