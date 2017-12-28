" Vim syntax file
" Language: HP Fortify SCA NST

if exists("b:current_syntax")
    finish
endif

" Source info
syntax match FortifyNSTSourceinfo '#\d\+#'
syntax match FortifyNSTNumber '\d\+' contained
syntax region FortifyNSTColNum start="#" end="#" contains=FortifyNSTNumber conceal
syntax match FortifyNSTSourceinfo '#source-line\s\+\S\+'
syntax match FortifyNSTSourceinfo '#source-file\s\+\S\+'
syntax match FortifyNSTSourceinfo '#source-type\s\+\S\+'

" Operator
syntax match FortifyNSTOperator ':[=.]:'
syntax match FortifyNSTOperator /:\S\+:/
syntax match FortifyNSTOperator /[-~]\+>/
syntax match FortifyNSTOperator /\~/ contained

" Method calls
syntax match FortifyNSTString /\~\zs[^~]\+\~\~[^~]\+\ze\~/ contains=FortifyOperator

" String
syntax region FortifyNSTString start=/"/ skip=/\\"/ end=/"/

" Containers
syntax match FortifyNSTBrackets /\[\s*\S\+\s*\]/ contains=FortifyNSTType
syntax match FortifyNSTVarDecl /\S\+\s*(\?\s*)\?\s*:\*:/ contains=FortifyNSTType,FortifyNSTOperator

" Type
syntax match nstType /[^\[\]:\*()]\+/ contained


let b:current_syntax = "fortifynst"

highlight default link FortifyNSTTilde Comment 
highlight default link FortifyNSTColNum Comment 
highlight default link FortifyNSTNumber Comment 
" highlight default link FortifyNSTSourceinfo  Comment
" highlight default link FortifyNSTOperator    PreProc
" highlight default link FortifyNSTString      String
" highlight default link FortifyNSTType        Type

set concealcursor=niv
set conceallevel=2
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
