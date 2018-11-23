let g:cobalt2_lightline = 1
let g:lightline = {
    \ 'colorscheme': 'cobalt2',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', ], [ 'anzu', 'filetype', ], [ 'filename', ], ],
    \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'column' ], [ 'percent' ], [ 'cwd', ] ]
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
    \   'tabs': 'LightlineBufferTabs',
    \   'tabs_usage': 'LightlineBufferTitle',
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \ },
    \ 'component_function': {
    \   'filetype': 'LightlineFiletype',
    \   'cwd': 'LightlineCwd',
    \   'filename': 'LightlineFilename',
    \   'anzu': 'LightlineAnzu',
    \   'deoplete': 'LightlineDeoplete',
    \ },
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \ 'tabline_separator': { 'left': ' ', 'right': ' ' },
    \ 'tabline_subseparator': { 'left': ' ', 'right': ' ' },
    \ }

function! LightlineDeoplete()
  if deoplete#is_enabled()
    return 'Deoplete enabled'
  endif
  return 'Deoplete disabled'
endfunction

function! LightlineAnzu()
  return anzu#search_status()
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

function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFilename()
    "let fname = fnamemodify(expand("%"), ":~:.")
    "let fname = winwidth(0) > 120 ? expand('%:p') : expand('%:t')
    let fname = expand('%:p')
    if (fname == '__Tagbar__' || fname == '__TestPane__' || fname == '__AuditPane__')
        let fname = ''
    else
        let width = winwidth(0) / 3 
        if strlen(fname) > width 
            let segments = reverse(split(fname, "/"))
            let truncated = ""
            for segment in segments
                let truncated  = "/" . segment . truncated 
                if strlen(truncated) > width
                    break
                endif
            endfor
            let fname = "..." . truncated
        endif
    endif
    return '' != fname ? fname : '[No Name]'
endfunction

function! LightlineCwd()
    "return fnamemodify(getcwd(), ':~')
    return winwidth(0) < 120 ? '' : getcwd()
endfunction



