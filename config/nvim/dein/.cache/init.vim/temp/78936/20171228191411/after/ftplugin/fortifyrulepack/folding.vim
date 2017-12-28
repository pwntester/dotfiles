" function! RulePackFolds(lnum)
"   let l:line = getline(a:lnum)
"   if a:lnum > 0
"     let l:linebefore = getline(a:lnum - 1)
"   else
"     let l:linebefore = ''
"   endif

"   if a:lnum == 0
"     return '0'
"   elseif l:line =~ '\v^\s*\<[a-zA-Z]+Rule\s+.*$'
"     return '0'
"   elseif l:line =~ '\v^\s*\</[a-z]+Rule\>\s*$'
"     return '1'
"   elseif l:linebefore =~ '\v^\s*\<[a-zA-Z]+Rule\s+.*$'
"     return '1'
"   elseif l:linebefore =~ '\v^\s*\</[a-z]+Rule\>\s*$'
"     return '0'
"   else
"     return '-1'
"   endif
" endfunction

" function! RulePackFoldLabel()
"   return ''
" endfunction

" if g:fortify_FoldRules == 1
"     setlocal foldmethod=expr
"     setlocal foldexpr=RulePackFolds(v:lnum)
"     setlocal foldtext=RulePackFoldLabel()
" else
"     " Enable for testing (Experimental)
"     " setlocal foldmethod=manual
"     " setlocal foldexpr=
"     " setlocal foldtext=
"     set nofoldenable
" endif
