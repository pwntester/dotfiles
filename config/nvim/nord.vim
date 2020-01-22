function! Nord() abort
    colorscheme nord 

    " Statusline
    hi MyStatuslineSeparator    guifg=#2e3440 guibg=#2e3440  
    hi MyStatuslineBar          guifg=#2e3440 guibg=#2e3440 
    hi MyStatuslineGit          guifg=#9E9E9E guibg=#2e3440
    hi MyStatuslineFiletype     guifg=#668799 guibg=#2e3440
    hi MyStatuslinePercentage   guifg=#668799 guibg=#2e3440
    hi MyStatuslineLineCol      guifg=#668799 guibg=#2e3440   
    hi MyStatuslineLSPErrors    guifg=#bf616a guibg=#2e3440
    hi MyStatuslineLSPWarnings  guifg=#d08770 guibg=#2e3440
    hi MyStatuslineLSP          guifg=#668799 guibg=#2e3440
    hi MyStatuslineBarNC        guifg=#2e3440 guibg=#434c5e

    function! RedrawModeColors(mode) abort
      " Normal mode
      if a:mode == 'n'
        hi MyStatuslineFilename     guifg=#88c0d0 guibg=#2e3440
      " Insert mode
      elseif a:mode == 'i'
        hi MyStatuslineFilename     guifg=#a3be8c guibg=#2e3440    
      " Replace mode
      elseif a:mode == 'R'
        hi MyStatuslineFilename     guifg=#967EFB guibg=#2e3440    
      " Visual mode
      elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
        hi MyStatuslineFilename     guifg=#d08770 guibg=#2e3440    
      " Command mode
      elseif a:mode == 'c'
        hi MyStatuslineFilename     guifg=#b48ead guibg=#2e3440    
      " Terminal mode
      elseif a:mode == 't'
        hi MyStatuslineFilename     guifg=#a3be8c guibg=#2e3440    
      endif
      " Return empty string so as not to display anything in the statusline
      return ''
    endfunction

    hi Normal   guibg=#2e3440
    hi NormalNC guibg=#434c5e
    hi def link StatusLineNC NormalNC
    hi EndOfBufferNC guifg=#3B4252 guibg=#434c5e

    let g:fzf_colors =
          \ { 'fg':      ['fg', 'Normal'],
          \ 'bg':      ['bg', 'Normal'],
          \ 'hl':      ['fg', 'Comment'],
          \ 'fg+':     ['fg', 'CursorLine'],
          \ 'bg+':     ['bg', 'Normal'],
          \ 'hl+':     ['fg', 'Statement'],
          \ 'info':    ['fg', 'PreProc'],
          \ 'border':  ['fg', 'CursorLine'],
          \ 'prompt':  ['fg', 'Conditional'],
          \ 'pointer': ['fg', 'Exception'],
          \ 'marker':  ['fg', 'Keyword'],
          \ 'spinner': ['fg', 'Label'],
          \ 'header':  ['fg', 'Comment'] }
endfunction

