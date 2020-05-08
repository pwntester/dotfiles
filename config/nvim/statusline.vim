function! RedrawModeColors(mode) abort

    let bg_color = GetColorFromHighlight("Normal", "bg")
    let blue = GetColorFromHighlight("SpecialKey", "fg")
    let green = GetColorFromHighlight("Title", "fg")
    let orange = GetColorFromHighlight("Identifier", "fg")
    let grey = GetColorFromHighlight("PMenu", "fg")
    let grey2 = GetColorFromHighlight("Directory", "fg")
    let yellow = GetColorFromHighlight("Function", "fg")

    " Normal mode
    if a:mode == 'n'
        execute("hi MyStatuslineFilename guifg=".yellow." guibg=".bg_color)
    " Insert mode
    elseif a:mode == 'i'
        execute("hi MyStatuslineFilename guifg=".blue." guibg=".bg_color)
    " Replace mode
    elseif a:mode == 'R'
        execute("hi MyStatuslineFilename guifg=".green." guibg=".bg_color)
    " Visual mode
    elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
        execute("hi MyStatuslineFilename guifg=".orange." guibg=".bg_color)
    " Command mode
    elseif a:mode == 'c'
        execute("hi MyStatuslineFilename guifg=".grey2." guibg=".bg_color)
    " Terminal mode
    elseif a:mode == 't'
        execute("hi MyStatuslineFilename guifg=".grey." guibg=".bg_color)
    endif
    " Return empty string so as not to display anything in the statusline
    return ''
endfunction

function! Truncate_path(path) abort
    let fname = a:path
    let width = winwidth(0) / 4 
    if strlen(fname) > width 
        let segments = split(fname, '/')
        let reversed_segments = reverse(copy(segments))
        let truncated = ''
        for segment in reversed_segments
            let truncated  = '/' . segment . truncated 
            if strlen(truncated) > width
                break
            endif
        endfor
        let fname = '/'.segments[0].'/...'.truncated
    endif
    return fname
endfunction

function! Filename() abort
    if index(g:special_buffers, &filetype) > -1 | return '' | endif
    return Truncate_path(@%)
endfunction

function! SetFiletype(filetype) abort
  if a:filetype == ''
      return '-'
  else
      return a:filetype
  endif
endfunction

function! Git() abort
  if empty(fugitive#head()) 
     return ''
  else
     return " ".fugitive#head()
  endif
endfunction

function! HR(char) abort
    return repeat(a:char, winwidth(0))
endfunction

function! LspStatus() abort
    let sl = ''
    if luaeval('vim.lsp.buf.server_ready()')
        let sl.='%#MyStatuslineLSP#E:'
        let sl.='%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Error\")")}'
        let sl.='%#MyStatuslineLSP# W:'
        let sl.='%#MyStatuslineLSPWarnings#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Warning\")")}'
    endif
    return sl
endfunction

function! StatusLineNC() abort
    let &l:statusline='%#MyStatuslineBarNC#%{HR("▁")}'
endfunction

function! StatusLine() abort
    if index(g:special_buffers, &filetype) > -1 
        if &filetype == 'dirvish'
            let &l:statusline='%#MyStatuslineFiletype#%{Truncate_path(expand("%"))}'
        else
            let &l:statusline='%#MyStatuslineBar#%{HR("▃")}'
        endif
        return
    endif

    let statusline='%{RedrawModeColors(mode())}'

    " left side items
    
    " filename
    " let filename = Filename()
    " if !empty(filename)
    "     let statusline.='%#MyStatuslineGit#%{Filename()}'
    " endif
    " let statusline.=' '

    " right side items
    let statusline.='%='

    " cwd
    let cwds = getcwd()
    if !empty(cwds)
        let statusline.='%#MyStatuslineFilename#%{getcwd()}'
        let statusline.=' '
    endif

    " git
    let git = Git()
    if !empty(git)
        let statusline.='%#MyStatuslineGit#%{Git()}'
        let statusline.=' '
    endif

    " column and current scroll percentage
    let statusline.='%#MyStatuslineLineCol#%c'
    let statusline.='/%#MyStatuslinePercentage#%p'
    let statusline.=' '

    " filetype
    let statusline.='%#MyStatuslineGit#%{SetFiletype(&filetype)}'
    let statusline.=' '

    " LSP
    let statusline.='%#MyStatuslineLSP#'.LspStatus()
    let statusline.=' '

    " render statusline
    let &l:statusline = statusline
endfunction

" }}}
