" Vim syntax file
" Language: HP Fortify SCA Definition

if exists("b:current_syntax")
    finish
endif

" comments
syntax keyword FortifyDefinitionCommentTodo TODO FIXME XXX TBD contained
syntax region  FortifyDefinitionLineComment start=+\/\/+ end=+$+ keepend contains=FortifyDefinitionCommentTodo
syntax region  FortifyDefinitionComment start="/\*"  end="\*/" contains=FortifyDefinitionCommentTodo fold

" definitionString
syntax region FortifyDefinitionString1 start=/"/ skip=/\\"/ end=/"/
syntax region FortifyDefinitionString2 start=/'/ skip=/\\'/ end=/'/

" foreach
syntax match FortifyDefinitionForeachKeyword /foreach/ contained
syntax region FortifyDefinitionForeach start=/foreach\s\+[a-zA-Z]*\s\+{/ end=/}/ contains=FortifyDefinitionForeachKeyword,FortifyDefinitionTaintPredicate,FortifyDefinitionCharacterizationProperty

" taintflags
syntax match FortifyDefinitionTaintFlag /[A-Z_0-9][A-Z_0-9][A-Z_0-9]*/ contained containedin=FortifyDefinitionTaintPredicate,FortifyDefinitionTaintPredicate
syntax match FortifyDefinitionTaintSign /+/ contained
syntax match FortifyDefinitionTaintSign /-/ contained
syntax match FortifyDefinitionTaintOperator /&&/ contained
syntax match FortifyDefinitionTaintOperator /!/ contained
syntax match FortifyDefinitionTaintOperator /||/ contained
syntax region FortifyDefinitionTaintPredicate start=/,\s*{/ end=/}/ contains=FortifyDefinitionTaintFlag,FortifyDefinitionTaintSign
syntax region FortifyDefinitionTaintPredicate start=/,\s*\[/ end=/\]/ contains=FortifyDefinitionTaintFlag,FortifyDefinitionTaintOperator

" characterization properties 
syntax match FortifyDefinitionCharacterizationProperty /Calls\|CallsReturns\|CallsMethod\|CallsMap\|Label\|TaintSource\|TaintWrite\|TaintEntrypoint\|TaintSink\|TaintCleanse\|TaintTransfer/ 

let b:current_syntax = "fortifydefinition"

" highlight default link FortifyDefinitionCharacterizationProperty Tag
" highlight default link FortifyDefinitionLineComment Comment
" highlight default link FortifyDefinitionComment Comment
" highlight default link FortifyDefinitionString1 String
" highlight default link FortifyDefinitionString2 String
" highlight default link FortifyDefinitionTaintFlag Function
" highlight default link FortifyDefinitionTaintSign Identifier
" highlight default link FortifyDefinitionTaintOperator Identifier
" highlight default link FortifyDefinitionForeachKeyword Tag

