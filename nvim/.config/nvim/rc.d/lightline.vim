set showtabline=2 
let g:unite_force_overwrite_statusline = 0
let g:denite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:lightline = {
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ], [ 'cwd' ], [ 'anzu', 'readonly', 'filename', 'modified' ], ],
    \      'right': [ [ 'column' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype', 'neomake_errors', 'neomake_warnings', ] ]
    \ },
    \ 'tabline': {
    \     'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \ }, 
    \ 'component': {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \ },
    \ 'component_expand': {
    \     'buffercurrent': 'lightline#buffer#buffercurrent2',
    \     'neomake_errors': 'LightLineNeomakeErrors',
    \     'neomake_warnings': 'LightLineNeomakeWarnings',
    \ },
    \ 'component_type': {
    \     'neomake_errors': 'error',
    \     'neomake_warnings': 'warning',
    \ },
    \ 'component_function': {
    \     'bufferinfo': 'lightline#buffer#bufferinfo',
    \     'bufferbefore': 'lightline#buffer#bufferbefore',
    \     'bufferafter': 'lightline#buffer#bufferafter',
    \     'cwd': 'LightLineCwd',
    \     'anzu' : 'anzu#search_status',
    \     'filename': 'LightLineFilename',
    \ },
    \ 'separator': { 'left': '⮀', 'right': '⮂' },
    \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
    \ }

function! LightLineFilename()
    return fnamemodify(expand("%"), ":~:.")
endfunction

function! LightLineCwd()
    return fnamemodify(getcwd(), ':~')
endfunction

function! LightLineNeomakeErrors()
  if !exists(":Neomake") || ((get(neomake#statusline#QflistCounts(), "E", 0) + get(neomake#statusline#LoclistCounts(), "E", 0)) == 0)
    return ''
  endif
  return 'E:'.(get(neomake#statusline#LoclistCounts(), 'E', 0) + get(neomake#statusline#QflistCounts(), 'E', 0))
endfunction

function! LightLineNeomakeWarnings()
  if !exists(":Neomake") || ((get(neomake#statusline#QflistCounts(), "W", 0) + get(neomake#statusline#LoclistCounts(), "W", 0)) == 0)
    return ''
  endif
  return 'W:'.(get(neomake#statusline#LoclistCounts(), 'W', 0) + get(neomake#statusline#QflistCounts(), 'W', 0))
endfunction
