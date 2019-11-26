let g:cobalt2_lightline = 1
let g:lightline = {
    \ 'colorscheme': 'cobalt2',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', ], [ 'indicator', 'anzu', 'fugitive', ], [ 'filename', ], ],
    \   'right': [ [ 'lsp_status_off', 'lsp_status_on', 'linter_warnings', 'linter_errors' ], [ 'filetype' ], [ 'cwd', 'column' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ ] ],
    \   'right': [ [ ], [ ] ]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'tabs', ], ],
    \   'right': [ [ 'tabs_usage', ] ],
    \ },
    \ 'component': {
    \   'indicator': '%{LineNoIndicator()}'
    \ },
    \ 'component_expand': {
    \   'tabs': 'BufferTabs',
    \   'tabs_usage': 'BufferTitle',
    \   'linter_warnings': 'LSPWarnings',
    \   'linter_errors': 'LSPErrors',
    \   'lsp_status_on': 'LSPStatusOn',
    \   'lsp_status_off': 'LSPStatusOff',
    \ },
    \ 'component_type': {
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'lsp_status_off': 'disabled',
    \   'lsp_status_on': 'enabled',
    \ },
    \ 'component_function': {
    \   'fugitive': 'Fugitive',
    \   'filetype': 'Filetype',
    \   'cwd': 'Cwd',
    \   'filename': 'Filename',
    \   'anzu': 'Anzu',
    \ },
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \ 'tabline_separator': { 'left': ' ', 'right': ' ' },
    \ 'tabline_subseparator': { 'left': ' ', 'right': ' ' },
    \ }

function! Anzu()
  return anzu#search_status()
endfunction

function! LSPErrors()
  return 2
endfunction

function! LSPWarnings()
  return 2
endfunction

function! LSPStatusOn()
  return "LSP"
endfunction

function! LSPStatusOff()
  return ""
endfunction

function! BufferTitle()
    return "buffers"
endfunction

function! LSP()
    return luaeval('get_lsp_client_status()')
endfunction

function! BufferTabs()
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
    let tabline_before = map(tabline_before, "NameBuffer(v:val)")
    let tabline_current = map(tabline_current, "NameBuffer(v:val)")
    let tabline_after = map(tabline_after, "NameBuffer(v:val)")
    return [tabline_before, tabline_current, tabline_after]
endfunction

function! NameBuffer(bufid)
    return (getbufvar(a:bufid, '&readonly')? '⭤ ':'') . (fnamemodify(bufname(a:bufid), ':t')==''? '[no name]' : fnamemodify(bufname(a:bufid), ':t')) . (getbufvar(a:bufid, '&mod')?' *':'')
endfunction

function! Filetype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : '') : ''
endfunction

function! Filename()
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

function! Cwd()
    return winwidth(0) < 120 ? '' : getcwd()
endfunction

function! QuickFixWarnings()
  let current_buf_number = bufnr('%')
  let list = getqflist()
  let current_buf_diagnostics = filter(list, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'W'})
  let count = len(current_buf_diagnostics)
  return count > 0 ? 'W: ' . count : ''
endfunction

function! QuickFixErrors()
  let current_buf_number = bufnr('%')
  let list = getqflist()
  let current_buf_diagnostics = filter(list, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'E'})
  let count = len(current_buf_diagnostics)
  return count > 0 ? 'E: ' . count : ''
endfunction

function! LocationListWarnings()
  let current_buf_number = bufnr('%')
  let list = getloclist(0)
  let current_buf_diagnostics = filter(list, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'W'})
  let count = len(current_buf_diagnostics)
  return count > 0 ? 'W: ' . count : ''
endfunction

function! LocationListErrors()
  let current_buf_number = bufnr('%')
  let list = getloclist(0)
  let current_buf_diagnostics = filter(list, {index, dict -> dict['bufnr'] == current_buf_number && dict['type'] == 'E'})
  let count = len(current_buf_diagnostics)
  return count > 0 ? 'E: ' . count : ''
endfunction

function! Fugitive() abort
  if index(g:special_buffers, &filetype) > -1 || fugitive#head() == "" 
     return ''
  else
     return " ".fugitive#head()
  endif
endfunction
