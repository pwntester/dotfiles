" vim-commentary
if exists("g:loaded_commentary")
  setlocal commentstring=//\ %s
endif

" OmniComplete
setlocal omnifunc=fortify#Complete
setlocal completefunc=fortify#Complete

" Indentation
setlocal shiftwidth=4 softtabstop=4 tabstop=4 et

