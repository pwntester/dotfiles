" Vim syntax file
" Language: HP Fortify SCA Rulepack

runtime! syntax/xml.vim

" Regexps
syntax region  FortifyRulepackRegexpCharClass  start=+\[+ skip=+\\.+ end=+\]+ contained
syntax match   FortifyRulepackRegexpBoundary   "\v%(\<@![\^$]|\\[bB])" contained
syntax match   FortifyRulepackRegexpBackRef    "\v\\[1-9][0-9]*" contained
syntax match   FortifyRulepackRegexpQuantifier "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??" contained
syntax match   FortifyRulepackRegexpOr         "\v\<@!\|" contained
syntax match   FortifyRulepackRegexpMod        "\v\(@<=\?[:=!>]" contained
syntax cluster FortifyRulepackRegexpSpecial    contains=FortifyRulepackRegexpBoundary,FortifyRulepackRegexpBackRef,FortifyRulepackRegexpQuantifier,FortifyRulepackRegexpOr,FortifyRulepackRegexpMod
syntax region  FortifyRulepackRegexpGroup      start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contained contains=FortifyRulepackRegexpCharClass,@FortifyRulepackRegexpSpecial keepend
syntax region  FortifyRulepackRegexpString     start=+\(\(\(return\|case\)\s\+\)\@<=\|\(\([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\(\\.\|[^]]\)*\]+ end=+/[gimy]\{,4}+ contains=FortifyRulepackRegexpCharClass,FortifyRulepackRegexpGroup,@FortifyRulepackRegexpSpecial oneline keepend

" XMLTag 
syntax cluster XMLTagBasic contains=xmlTag,xmlEndTag,xmlCdata,xmlCdataCdata,xmlCdataStart,xmlCdataEnd

" Patterns
syntax region patternTag start=+<Pattern\>+ keepend end=+</Pattern>+ contains=@XMLTagBasic,FortifyRulepackRegexpCharClass,FortifyRulepackRegexpGroup,@FortifyRulepackRegexpSpecial 


" TaintFlags
syntax region FortifyRulepackTaintFlagsTag start=+<TaintFlags\>+ keepend end=+</TaintFlags>+ contains=xmlTag,xmlEndTag,FortifyRulepackTaintFlag,FortifyRulepackTaintFlagSign
syntax match FortifyRulepackTaintFlagSign "[+\-]" contained containedin=FortifyRulepackTaintFlagsTag
syntax match FortifyRulepackTaintFlag "[A-Z0-9_\-]" contained containedin=FortifyRulepackTaintFlagsTag

" RuleId
syntax match FortifyRulepackRuleIDDash "[+\-_]" contained
syntax match FortifyRulepackRuleIDChars "[a-zA-Z0-9]" contained
syntax region FortifyRulepackRuleIDTag start=+<RuleID\>+ keepend end=+</RuleID>+ contains=FortifyRulepackRuleIDDash,FortifyRulepackRuleIDChars,xmlTag,xmlEndTag

" Embedded Structural
unlet! b:current_syntax
syntax include @ftfyStructural syntax/fortifystructural.vim
syntax region structuralRegion start=+<Predicate\>+ keepend end=+</Predicate>+ contains=@XMLTagBasic,@ftfyStructural
syntax region structuralRegion start=+<StructuralMatch\>+ keepend end=+</StructuralMatch>+ contains=@XMLTagBasic,@ftfyStructural

" Embedded Javascript
unlet! b:current_syntax
syntax include @Javascript syntax/javascript.vim
syntax region javascriptRegion start=+<ScriptDefinition\>+ keepend end=+</ScriptDefinition>+ contains=@XMLTagBasic,@Javascript
syntax region javascriptRegion start=+<Script\>+ keepend end=+</Script>+ contains=@XMLTagBasic,@Javascript
syntax region javascriptRegion start=+<CallGraphScript\>+ keepend end=+</CallGraphScript>+ contains=@XMLTagBasic,@Javascript

" Embedded Java
unlet! b:current_syntax
syntax include @Java syntax/java.vim
syntax region javaRegion start=+<Code\>+ keepend end=+</Code>+ contains=@XMLTagBasic,@Java

" Embedded Definition
unlet! b:current_syntax
syntax include @ftfyDefinition syntax/fortifydefinition.vim
syntax region FortifyRulepackDefinitionTag start=+<Definition\>+ keepend end=+</Definition>+ contains=@XMLTagBasic,@ftfyDefinition

let b:current_syntax = "fortifyrulepack"

" highlight default link FortifyRulepackRegexpString         Identifier
" highlight default link FortifyRulepackRegexpBoundary       Identifier
" highlight default link FortifyRulepackRegexpQuantifier     Identifier
" highlight default link FortifyRulepackRegexpOr             Identifier
" highlight default link FortifyRulepackRegexpMod            Identifier
" highlight default link FortifyRulepackRegexpBackRef        Identifier
" highlight default link FortifyRulepackRegexpGroup          FortifyRulepackRegexpString
" highlight default link FortifyRulepackRegexpCharClass      Identifier
"
" highlight default link FortifyRulepackRuleIDDash Identifier
" highlight default link FortifyRulepackRuleIDChars Function
" highlight default link FortifyRulepackTaintFlagSign Identifier
" highlight default link FortifyRulepackTaintFlag Function
