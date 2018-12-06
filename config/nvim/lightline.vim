let g:cobalt2_lightline = 1
let g:lightline = {
    \ 'colorscheme': 'cobalt2',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', ], [ 'anzu', 'fugitive', ], [ 'filename', ], ],
    \   'right': [ [ 'linter_errors', 'linter_warnings', 'column', 'percent' ], [ 'filetype' ], [ 'cwd', ] ]
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
    \   'linter_warnings': 'LightlineLanguageClientWarnings',
    \   'linter_errors': 'LightlineLanguageClientErrors',
    \ },
    \ 'component_type': {
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightlineFugitive',
    \   'filetype': 'LightlineFiletype',
    \   'cwd': 'LightlineCwd',
    \   'filename': 'LightlineFilename',
    \   'anzu': 'LightlineAnzu',
    \ },
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \ 'tabline_separator': { 'left': ' ', 'right': ' ' },
    \ 'tabline_subseparator': { 'left': ' ', 'right': ' ' },
    \ }

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
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : '') : ''
endfunction

function! LightlineFilename()
    if index(g:special_buffers, &filetype) > -1
        return ''
    else
        let fname = expand('%:p')
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
        return fname
    endif
endfunction

function! LightlineCwd()
    return winwidth(0) < 120 ? '' : getcwd()
endfunction

function! LightlineLanguageClientWarnings()
  let current_buf_number = bufnr('%')
  let qflist = getqflist()
  let current_buf_diagnostics = filter(qflist, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'W'})
  let count = len(current_buf_diagnostics)
  return count > 0 && g:LanguageClient_loaded ? 'W: ' . count : ''
endfunction

function! LightlineLanguageClientErrors()
  let current_buf_number = bufnr('%')
  let qflist = getqflist()
  let current_buf_diagnostics = filter(qflist, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'E'})
  let count = len(current_buf_diagnostics)
  return count > 0 && g:LanguageClient_loaded ? 'E: ' . count : ''
endfunction

function! LightlineFugitive() abort
  if index(g:special_buffers, &filetype) > -1
    return ''
  else
     return " ".fugitive#head()
  endif
endfunction
