let g:cobalt2_lightline = 1
let g:lightline = {
    \ 'colorscheme': 'cobalt2',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', ], [ 'fugitive', 'filetype', ], [ 'filename', ], ],
    \   'right': [ ['neomake_errors', 'neomake_warnings', 'column' ], [ 'percent' ], [ 'cwd', ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ ] ],
    \   'right': [ [ ], [ ] ]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'tabs', ], ],
    \   'right': [ [ 'tabs_usage', ] ],
    \ },
    \ 'component_expand': {
    \   'neomake_errors': 'LightlineNeomakeErrors',
    \   'neomake_warnings': 'LightlineNeomakeWarnings',
    \   'tabs': 'LightlineBufferTabs',
    \   'tabs_usage': 'LightlineBufferTitle',
    \ },
    \ 'component_type': {
    \   'neomake_errors': 'error',
    \   'neomake_warnings': 'warning',
    \ },
    \ 'component_function': {
    \   'cwd': 'LightlineCwd',
    \   'filename': 'LightlineFilename',
    \   'fugitive': 'LightlineFugitive',
    \   'deoplete': 'LightlineDeoplete',
    \ },
    \ 'separator': { 'left': '⮀', 'right': '⮂' },
    \ 'subseparator': { 'left': '⮁', 'right': '⮃' },
    \ 'tabline_separator': { 'left': ' ', 'right': ' ' },
    \ 'tabline_subseparator': { 'left': ' ', 'right': ' ' },
    \ }

function! LightlineDeoplete()
  if deoplete#is_enabled()
    return 'Deoplete enabled'
  endif
  return 'Deoplete disabled'
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|fortifytestpane\|fortifyauditpane\|fortifycategory\|tagbar' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? '⭠ '.branch : ''
  endif
  return ''
endfunction

function! LightlineBufferTitle()
    return "buffers"
endfunction

function! LightlineBufferTabs()
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
    let tabline_before = map(tabline_before, "(getbufvar(v:val, '&readonly')? '⭤ ':'') . fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    let tabline_current = map(tabline_current, "(getbufvar(v:val, '&readonly')? '⭤ ':'') .fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    let tabline_after = map(tabline_after, "(getbufvar(v:val, '&readonly')? '⭤ ':'') .fnamemodify(bufname(v:val), ':t') . (getbufvar(v:val, '&mod')?' *':'')")
    return [tabline_before, tabline_current, tabline_after]
endfunction

function! LightlineFilename()
  let fname = fnamemodify(expand("%"), ":~:.")
  return 
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname == '__TestPane__' ? '' :
        \ fname == '__AuditPane__' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ ('' != fname ? fname : '[No Name]')
endfunction

function! LightlineCwd()
    return fnamemodify(getcwd(), ':~')
endfunction

function! LightlineNeomakeErrors()
  if !exists(":Neomake") || ((get(neomake#statusline#QflistCounts(), "E", 0) + get(neomake#statusline#LoclistCounts(), "E", 0)) == 0)
    return ''
  endif
  return 'E:'.(get(neomake#statusline#LoclistCounts(), 'E', 0) + get(neomake#statusline#QflistCounts(), 'E', 0))
endfunction

function! LightlineNeomakeWarnings()
  if !exists(":Neomake") || ((get(neomake#statusline#QflistCounts(), "W", 0) + get(neomake#statusline#LoclistCounts(), "W", 0)) == 0)
    return ''
  endif
  return 'W:'.(get(neomake#statusline#LoclistCounts(), 'W', 0) + get(neomake#statusline#QflistCounts(), 'W', 0))
endfunction
