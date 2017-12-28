" Vim syntax file
" Language: HP Fortify SCA Description

runtime! syntax/xml.vim

" XMLTag 
syn cluster XMLTagBasic contains=xmlTag,xmlEndTag,xmlCdata,xmlCdataCdata,xmlCdataStart,xmlCdataEnd

unlet! b:current_syntax

syntax region FortifyDescriptionXMLAttribute start=/"/ end=/"/ contains=@NoSpell containedin=xmlTag
syntax match FortifyDescriptionPlaintext "[0-9a-zA-Z\-:_()/\[\]]" containedin=code,b,FortifyDescriptionPlaintext
syntax region b start=/<b>/ keepend end=/<\/b>/ contains=@XMLTagBasic,plaintext
syntax region code start=/<code>/ keepend end=/<\/code>/ contains=@NoSpell,@XMLTagBasic,FortifyDescriptionPlaintext

" PRE generic syntax
syntax region pre start=/<pre>/ keepend end=/<\/pre>/ contains=@NoSpell,@XMLTagBasic 
syntax region FortifyDescriptionPreString start=/"/ end=/"/ contains=@NoSpell containedin=pre

syntax region abstract start=/<Abstract/ keepend end=/<\/Abstract>/ contains=@Spell,@XMLTagBasic,code,b,pre,replacement
syntax region explanation start=/<Explanation/ keepend end=/<\/Explanation>/ contains=@Spell,@XMLTagBasic,code,b,pre,replacement
syntax region recommendations start=/<Recommendations/ keepend end=/<\/Recommendations>/ contains=@Spell,@XMLTagBasic,code,b,pre
syntax region tip start=/<Tip>/ keepend end=/<\/Tip>/ contains=@Spell,@XMLTagBasic
syntax region title start=/<Title>/ keepend end=/<\/Title>/ contains=@NoSpell,plaintext,@XMLTagBasic
syntax region author start=/<Author>/ keepend end=/<\/Author>/ contains=@NoSpell,@XMLTagBasic
syntax region publisher start=/<Publisher>/ keepend end=/<\/Publisher>/ contains=@NoSpell,@XMLTagBasic
syntax region source start=/<Source>/ keepend end=/<\/Source>/ contains=@NoSpell,@XMLTagBasic
syntax region date start=/<PublishedDate>/ keepend end=/<\/PublishedDate>/ contains=@NoSpell,@XMLTagBasic

unlet! b:current_syntax
let b:current_syntax = "fortifydescription"

" highlight default link FortifyDescriptionXMLAttribute Function 
" highlight default link FortifyDescriptionPreString String 
" highlight default link FortifyDescriptionPlaintext Function
