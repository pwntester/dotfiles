function! RedrawModeColors(mode) abort
  " Normal mode
  if a:mode == 'n'
    hi MyStatuslineFilename     guifg=#00AAFF guibg=#17252c    
  " Insert mode
  elseif a:mode == 'i'
    hi MyStatuslineFilename     guifg=#88FF88 guibg=#17252c    
  " Replace mode
  elseif a:mode == 'R'
    hi MyStatuslineFilename     guifg=#967EFB guibg=#17252c    
  " Visual mode
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
    hi MyStatuslineFilename     guifg=#FF9A00 guibg=#17252c    
  " Command mode
  elseif a:mode == 'c'
    hi MyStatuslineFilename     guifg=#668799 guibg=#17252c    
  " Terminal mode
  elseif a:mode == 't'
    hi MyStatuslineFilename     guifg=#CCCCCC guibg=#17252c    
  endif
  " Return empty string so as not to display anything in the statusline
  return ''
endfunction

function! SetFiletype(filetype) abort
  if a:filetype == ''
      return '-'
  else
      return a:filetype
  endif
endfunction

function! LSPErrors() abort
    let l:metrics = luaeval("get_lsp_diagnostic_metrics()")
    if type(l:metrics) == v:t_dict
        return l:metrics['errors']
    else
        return ''
    endif
endfunction

function! LSPWarnings() abort
    let l:metrics = luaeval("get_lsp_diagnostic_metrics()")
    if type(l:metrics) == v:t_dict
        return l:metrics['warnings']
    else
        return ''
    endif
endfunction

function! Filename() abort
    if index(g:special_buffers, &filetype) > -1 | return '' | endif

    let fname = @%
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

function! StatusLineNC() abort
    if index(g:special_buffers, &filetype) > -1 
        let &l:statusline=' '
    else
        let &l:statusline='%#MyStatuslineBarNC#%{HR("▁")}'
    endi
endfunction

function! StatusLine() abort
    if index(g:special_buffers, &filetype) > -1 
        let &l:statusline='%#MyStatuslineBar#%{HR("▃")}'
        return
    endif

    let statusline='%{RedrawModeColors(mode())}'

    " Left side items
    " Filename
    let cwds = getcwd()
    if !empty(cwds)
        let statusline.='%#MyStatuslineSeparator# '
        let statusline.='%#MyStatuslineFilename#%{getcwd()}'
        let statusline.='%#MyStatuslineSeparator#'
    else
    endif
    let filename = Filename()
    if !empty(filename)
        let statusline.='%#MyStatuslineSeparator# '
        let statusline.='%#MyStatuslineFilename#%{Filename()}'
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.=' '
    endif

    " Git
    let git = Git()
    if !empty(git)
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.='%#MyStatuslineGit#%{Git()}'
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.=' '
    endif

    " Right side items
    let statusline.='%='

    " Line and column and current scroll percentage
    let statusline.='%#MyStatuslineSeparator#'
    let statusline.='%#MyStatuslineLineCol#%2l'
    let statusline.='/%#MyStatuslineLineCol#%2c'
    let statusline.='/%#MyStatuslinePercentage#%2p'
    let statusline.='%#MyStatuslineSeparator#'
    let statusline.=' '

    " Filetype
    let statusline.='%#MyStatuslineSeparator#'
    let statusline.='%#MyStatuslineFiletype#%{SetFiletype(&filetype)}'
    let statusline.='%#MyStatuslineSeparator#'
    let statusline.=' '

    " LSP
    if luaeval('get_lsp_client_status()')
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.='%#MyStatuslineLSP#E:'
        let statusline.='%#MyStatuslineLSPErrors#%{LSPErrors()}'
        let statusline.='%#MyStatuslineLSP# W:'
        let statusline.='%#MyStatuslineLSPWarnings#%{LSPWarnings()}'
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.=' '
    else
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.='%#MyStatuslineLSPErrors#LSP off'
        let statusline.='%#MyStatuslineSeparator#'
        let statusline.=' '
    endif
    let &l:statusline = statusline
endfunction

" }}}

" Setup the colors
hi MyStatuslineSeparator    guifg=#17252c guibg=#020511  
hi MyStatuslineGit          guifg=#9E9E9E guibg=#17252c
hi MyStatuslineFiletype     guifg=#668799 guibg=#17252c
hi MyStatuslinePercentage   guifg=#668799 guibg=#17252c
hi MyStatuslineLineCol      guifg=#668799 guibg=#17252c   
hi MyStatuslineLSPErrors    guifg=#F02020 guibg=#17252c
hi MyStatuslineLSPWarnings  guifg=#FF9A00 guibg=#17252c
hi MyStatuslineLSP          guifg=#9E9E9E guibg=#17252c
hi MyStatuslineBar          guifg=#17252c guibg=#020511 
hi MyStatuslineBarNC        guifg=#020511 guibg=#17252c
