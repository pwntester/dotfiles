" Vim syntax file
" Language: HP Fortify SCA Structural

if exists("b:current_syntax")
    finish
  endif

" Regexps
syntax region  FortifyStructuralRegexpCharClass  start=+\[+ skip=+\\.+ end=+\]+ contained
syntax match   FortifyStructuralRegexpBoundary   "\v%(\<@![\^$]|\\[bB])" contained
syntax match   FortifyStructuralRegexpBackRef    "\v\\[1-9][0-9]*" contained
syntax match   FortifyStructuralRegexpQuantifier "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??" contained
syntax match   FortifyStructuralRegexpOr         "\v\<@!\|" contained
syntax match   FortifyStructuralRegexpMod        "\v\(@<=\?[:=!>]" contained
syntax cluster FortifyStructuralRegexpSpecial contains=FortifyStructuralRegexpBoundary,FortifyStructuralRegexpBackRef,FortifyStructuralRegexpQuantifier,FortifyStructuralRegexpOr,FortifyStructuralRegexpMod
syntax region  FortifyStructuralRegexpGroup start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contained contains=FortifyStructuralRegexpCharClass,@FortifyStructuralRegexpSpecial keepend
syntax region  FortifyStructuralRegexpString start=+\(\(\(return\|case\)\s\+\)\@<=\|\(\([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\(\\.\|[^]]\)*\]+ end=+/[gimy]\{,4}+ contains=FortifyStructuralRegexpCharClass,FortifyStructuralRegexpGroup,@FortifyStructuralRegexpSpecial oneline keepend

" comments
syntax keyword FortifyStructuralCommentTodo TODO FIXME XXX TBD contained
syntax region  FortifyStructuralLineComment start=+\/\/+ end=+$+ keepend contains=FortifyStructuralCommentTodo
syntax region  FortifyStructuralComment start="/\*"  end="\*/" contains=FortifyStructuralCommentTodo fold

" FortifyStructuralOperator
syntax match FortifyStructuralOperator /\s\(==\|===\|!=\|not\|and\s\+not\|or\s\+not\|matches\|in\|is\|contains\|startsWith\|endsWith\|reaches\|reachedBy\|and\|or\|!\||\|&\|+\|-\|<\|>\|=\|%\|\/\|*\|\~\|\^\)\s/

" FortifyStructuralString
syntax region FortifyStructuralString start=/"/ skip=/\\"/ end=/"/
syntax region FortifyStructuralString start=/'/ skip=/\\'/ end=/'/

" FortifyStructuralType
syntax match FortifyStructuralColon /:/ contained
syntax match FortifyStructuralVariable /[A-Za-z0-9]*:/ contains=FortifyStructuralColon contained
syntax match FortifyStructuralType /\w\+:/  contains=FortifyStructuralColon
syntax match FortifyStructuralType /\w\+\s\+[A-Za-z0-9]*:/ contains=FortifyStructuralVariable

" Patterns
syntax match FortifyStructuralMatches /\s\+matches\s\+/ contained
syntax region FortifyStructuralPatternString start=/\s\+matches\s\+"/ skip=/\\"/ end=/"/ contains=FortifyStructuralMatches,FortifyStructuralRegexpCharClass,FortifyStructuralRegexpGroup,@FortifyStructuralRegexpSpecial keepend

let b:current_syntax = "fortifyFortifyStructural"

" highlight default link FortifyStructuralType Tag
" highlight default link FortifyStructuralString String
" highlight default link FortifyStructuralOperator Identifier
" highlight default link FortifyStructuralMatches Identifier
" highlight default link FortifyStructuralVariable Type
" highlight default link FortifyStructuralLineComment Comment
" highlight default link FortifyStructuralComment Comment
"
" highlight default link FortifyStructuralRegexpString         Identifier
" highlight default link FortifyStructuralRegexpBoundary       Identifier
" highlight default link FortifyStructuralRegexpQuantifier     Identifier
" highlight default link FortifyStructuralRegexpOr             Identifier
" highlight default link FortifyStructuralRegexpMod            Identifier
" highlight default link FortifyStructuralRegexpBackRef        Identifier
" highlight default link FortifyStructuralRegexpGroup          FortifyStructuralRegexpString
" highlight default link FortifyStructuralRegexpCharClass      Identifier


