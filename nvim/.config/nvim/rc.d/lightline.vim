let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', 'anzu', ], [ 'filetype', ], [ 'readonly', 'filename', ], ],
    \   'right': [ ['neomake_errors', 'neomake_warnings', 'column' ], [ 'percent' ], [ 'cwd', ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ ] ],
    \   'right': [ [ ], [ ] ]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'tabs', ], ],
    \   'right': [ [ ] ],
    \ },
    \ 'component': {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \ },
    \ 'component_expand': {
    \   'neomake_errors': 'LightLineNeomakeErrors',
    \   'neomake_warnings': 'LightLineNeomakeWarnings',
    \   'tabs': 'LightLineBufferTabs',
    \ },
    \ 'component_type': {
    \   'neomake_errors': 'error',
    \   'neomake_warnings': 'warning',
    \ },
    \ 'component_function': {
    \   'cwd': 'LightLineCwd',
    \   'anzu' : 'LightLineAnzu',
    \   'filename': 'LightLineFilename',
    \ },
    \ 'separator': { 'left': '⮀', 'right': '⮂' },
    \ 'subseparator': { 'left': '⮁', 'right': '⮃' },
    \ 'tabline_separator': { 'left': ' ', 'right': ' ' },
    \ 'tabline_subseparator': { 'left': ' ', 'right': ' ' },
    \ }

function! LightLineBufferTabs()
    let buflist = filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")') 
    let tabline_before = []
    let tabline_current = []
    let tabline_after = []
    let isBeforeCurrent = 1
    for buf_nr in buflist
        if buf_nr == winbufnr(0)
            let isBeforeCurrent = 0
            let tabline_current += [buf_nr]
        else
            if isBeforeCurrent
                let tabline_before += [buf_nr]
            else
                let tabline_after += [buf_nr]
            endif
        endif
    endfor
    let tabline_before = map(tabline_before, "fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    let tabline_current = map(tabline_current, "fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    let tabline_after = map(tabline_after, "fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    return [tabline_before, tabline_current, tabline_after]
endfunction

function! LightLineFilename()
    return fnamemodify(expand("%"), ":~:.")
endfunction

function! LightLineAnzu()
    let status = anzu#search_status()
    if status == ""
        return ''
    else
        return split(split(status, "(")[1], ')')[0]
    endif
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
