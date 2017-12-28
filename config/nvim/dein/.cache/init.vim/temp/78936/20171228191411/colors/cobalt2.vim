" ===============================================================
" cobalt2
" 
" URL: http://github.com/pwntester/vim-cobalt2
" Author: Alvaro Muñoz (@pwntester)
" License: MIT
" Last Change: 2017/05/21 18:39
" ===============================================================

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="cobalt2"

hi Directory guifg=#FFC600 ctermfg=220
hi DiffAdd guifg=#3AD900 ctermfg=76
hi DiffAdded guifg=#3AD900 ctermfg=76
hi DiffChange guibg=#2D7067 ctermbg=242
hi DiffDelete guifg=#1C1C1C ctermfg=234 guibg=#700009 ctermbg=1
hi DiffText guifg=#8fbfdc ctermfg=110 guibg=#1C1C1C ctermbg=234 gui=reverse cterm=reverse
hi DiffRemoved guifg=#FF628C ctermfg=204
hi ErrorMsg guibg=#902020 ctermbg=88
hi VertSplit guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Folded guifg=#9E9E9E ctermfg=247 guibg=#444444 ctermbg=238 gui=italic cterm=italic
hi MatchParen guifg=#FFFFFF ctermfg=15 guibg=#345FA8 ctermbg=61
hi MoreMsg guifg=#88FF88 ctermfg=120
hi NonText guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi PMenu guifg=#CCCCCC ctermfg=252 guibg=#3A3A3A ctermbg=237
hi PMenuSel guifg=#3A3A3A ctermfg=237 guibg=#FFC600 ctermbg=220
hi PmenuSbar guifg=#626262 ctermfg=241
hi PmenuThumb guifg=#CCCCCC ctermfg=252
hi Question guifg=#3AD900 ctermfg=76
hi Search guifg=#1C1C1C ctermfg=234 guibg=#F2ED7F ctermbg=228 gui=underline cterm=underline
hi SpecialKey guifg=#444444 ctermfg=238 guibg=#1C1C1C ctermbg=234
hi SpellBad guifg=#902020 ctermfg=88 gui=underline cterm=underline
hi SpellLocal guibg=#2D7067 ctermbg=242 gui=underline cterm=underline
hi SpellCap guibg=#0000df ctermbg=20 gui=underline cterm=underline
hi SpellRare guibg=#4F0037 ctermbg=53 gui=underline cterm=underline
hi StatusLine guifg=#1C1C1C ctermfg=234 guibg=#CCCCCC ctermbg=252 gui=italic cterm=italic
hi StatusLineNC guifg=#FFFFFF ctermfg=15 guibg=#444444 ctermbg=238 gui=italic cterm=italic
hi TabLine guifg=#FFFFFF ctermfg=15 guibg=#3A3A3A ctermbg=237 gui=underline cterm=underline
hi TabLineFill guifg=#FFFFFF ctermfg=15 guibg=#9E9E9E ctermbg=247 gui=underline cterm=underline
hi TabLineSel guifg=#3A3A3A ctermfg=237 guibg=#FFC600 ctermbg=220 gui=bold,underline cterm=bold,underline
hi Title guifg=#70b950 ctermfg=71 gui=bold cterm=bold
hi WildMenu guifg=#F0A0C0 ctermfg=217 guibg=#3A3A3A ctermbg=237
hi Comment guifg=#0088FF ctermfg=33 gui=italic cterm=italic
hi Constant guifg=#FF628C ctermfg=204
hi String guifg=#3AD900 ctermfg=76
hi Identifier guifg=#FF9A00 ctermfg=208
hi Function guifg=#FFC600 ctermfg=220
hi Statement guifg=#FF9A00 ctermfg=208
hi Operator guifg=#0088FF ctermfg=33 gui=italic cterm=italic
hi PreProc guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Type guifg=#FFC600 ctermfg=220
hi StorageClass guifg=#FF9D00 ctermfg=214
hi Structure guifg=#0088FF ctermfg=33 gui=italic cterm=italic
hi Special guifg=#88FF88 ctermfg=120
hi Delimiter guifg=#668799 ctermfg=66
hi StringDelimiter guifg=#668799 ctermfg=66
hi Error guibg=#902020 ctermbg=88 gui=italic cterm=italic
hi Todo guibg=#0088FF ctermbg=33 gui=italic cterm=italic
hi ColorColumn guibg=#17252c ctermbg=235
hi Normal guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Cursor guifg=NONE ctermfg=NONE guibg=#3A3A3A ctermbg=237
hi CursorColumn guifg=NONE ctermfg=NONE guibg=#3A3A3A ctermbg=237 gui=NONE cterm=NONE
hi CursorLine guifg=NONE ctermfg=NONE guibg=#3A3A3A ctermbg=237 gui=NONE cterm=NONE
hi CursorLineNr guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE
hi FoldColumn guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi SignColumn guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi LineNr guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Visual guifg=#FFFFFF ctermfg=15 guibg=#0050A4 ctermbg=25
hi link cFormat Identifier
hi link cOperator Constant
hi cssPseudoClassFn guifg=#FF628C ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link cssPageAttr cssBoxAttr
hi link cssColorAttr cssBoxAttr
hi cssTagName guifg=#80FCFF ctermfg=123 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBackgroundProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBorderProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBoxProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssColorProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssDimensionProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssFontProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssPositioningProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssTextProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssTransformProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssTransitionProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssUIProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBackgroundAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBorderAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBoxAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssDimensionAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssFontAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssPositioningAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssTextAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssTransitionAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssUIAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssCommonAttr guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssPseudoClassId guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssValueLength guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssValueNumber guifg=#F2ED7F ctermfg=228 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssIdentifier guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssInclude guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssIncludeKeyword guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssBraces guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssMediaType guifg=#EB939A ctermfg=174 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssMediaKeyword guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssMediaProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssPageProp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssClassName guifg=#3AD900 ctermfg=76 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi cssUnitDecorators guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi deniteMatched guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi deniteMatchedChar guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link FortifyAuditPaneHelp Comment
hi link FortifyAuditPaneHelpKey Identifier
hi link FortifyAuditPaneHelpTitle PreProc
hi link FortifyAuditPaneCategoryCount Title
hi link FortifyAuditPaneDigit Text
hi link FortifyAuditPaneInfo Title
hi link FortifyAuditPaneTraces Title
hi link FortifyAuditPaneIssue Statement
hi link FortifyAuditPaneFoldIcon Title
hi link FortifyAuditPaneAltFoldIcon Keyword
hi link FortifyAuditPaneBracket Title
hi link FortifyAuditPaneRule Title
hi link FortifyAuditPaneFact Type
hi FortifyAuditPaneInCallIcon guifg=#3AD900 ctermfg=76 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneInOutCallIcon guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneOutCallIcon guifg=#FF0000 ctermfg=9 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneReadGlobalIcon guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneAssignGlobalIcon guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneAssignIcon guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneReturnIcon guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneExternalEntry guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneSeparator guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneRuleIcon guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneFile guifg=#626262 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneBranchTakenIcon guifg=#3AD900 ctermfg=76 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneBranchNotTakenIcon guifg=#FF0000 ctermfg=9 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneDefaultIcon guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneJumpIcon guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneFriorityLow guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneFriorityMedium guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneFriorityHigh guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyAuditPaneFriorityCritical guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link FortifyTestPaneCmd Comment
hi link FortifyTestPaneFile Title
hi FortifyTestPanePassed guifg=#3AD900 ctermfg=76 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi FortifyTestPaneFailed guifg=#FF0000 ctermfg=9 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link FortifyCategoryMapping Title
hi link FortifyDefinitionCharacterizationProperty Tag
hi link FortifyDefinitionLineComment Comment
hi link FortifyDefinitionComment Comment
hi link FortifyDefinitionString1 String
hi link FortifyDefinitionString2 String
hi link FortifyDefinitionTaintFlag Function
hi link FortifyDefinitionTaintSign Identifier
hi link FortifyDefinitionTaintOperator Identifier
hi link FortifyDefinitionForeachKeyword Tag
hi link FortifyDescriptionPlaintext Function
hi link FortifyDescriptionXMLAttribute Function
hi FortifyDescriptionPreString guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link FortifyNSTSourceinfo Comment
hi link FortifyNSTOperator PreProc
hi link FortifyNSTString String
hi link FortifyNSTType Type
hi link FortifyRulepackRuleIDDash Identifier
hi link FortifyRulepackRuleIDChars Function
hi link FortifyRulepackTaintFlagSign Identifier
hi link FortifyRulepackTaintFlag Function
hi link FortifyRulepackRegexpString Identifier
hi link FortifyRulepackRegexpBoundary Identifier
hi link FortifyRulepackRegexpQuantifier Identifier
hi link FortifyRulepackRegexpOr Identifier
hi link FortifyRulepackRegexpMod Identifier
hi link FortifyRulepackRegexpBackRef Identifier
hi link FortifyRulepackRegexpGroup Identifier
hi link FortifyRulepackRegexpCharClass Identifier
hi link FortifyStructuralType Tag
hi link FortifyStructuralString String
hi link FortifyStructuralOperator Identifier
hi link FortifyStructuralMatches Identifier
hi link FortifyStructuralVariable Type
hi link FortifyStructuralLineComment Comment
hi link FortifyStructuralComment Comment
hi link FortifyStructuralRegexpString Identifier
hi link FortifyStructuralRegexpBoundary Identifier
hi link FortifyStructuralRegexpQuantifier Identifier
hi link FortifyStructuralRegexpOr Identifier
hi link FortifyStructuralRegexpMod Identifier
hi link FortifyStructuralRegexpBackRef Identifier
hi link FortifyStructuralRegexpGroup Identifier
hi link FortifyStructuralRegexpCharClass Identifier
hi htmlItalic guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlTag guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlEndTag guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlArg guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlTagName guifg=#80FCFF ctermfg=123 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlSpecialTagName guifg=#00AAFF ctermfg=39 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlH1 guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlTitle guifg=#967EFB ctermfg=105 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlString guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi htmlEvent guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsFunction guifg=#EE80E1 ctermfg=212 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsFuncCall guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsOperator guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsStorageClass guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsFuncArgs guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsBuiltins guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsUndefined guifg=#FF628C ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsThis guifg=#EE80E1 ctermfg=212 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsPrototype guifg=#EB939A ctermfg=174 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link jsRegexpOr regex_or
hi link jsRegexpQuantifier regex_quantifier
hi link jsRegexpGroup regex_group
hi link jsRegexpBoundary regex_boundary
hi link jsRegexpCharClass regex_char_group
hi link jsRegexpString regex_string
hi jsRegexpMod guifg=#FE94FF ctermfg=213 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsRegexpBackRef guifg=#FF9D00 ctermfg=214 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link javaScriptValue Constant
hi javaScriptRegexpString guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsonKeywordMatch guifg=#0088FF ctermfg=33 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsonBraces guifg=#967EFB ctermfg=105 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsonQuote guifg=#0088FF ctermfg=33 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi jsonNoise guifg=#0088FF ctermfg=33 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownCode guifg=#9E9E9E ctermfg=247 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownCodeBlock guifg=#9E9E9E ctermfg=247 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH1 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH2 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH3 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH4 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH5 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownH6 guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownHeadingRule guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownHeadingDelimiter guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownRule guifg=#80FCFF ctermfg=123 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownLinkText guifg=#3AD900 ctermfg=76 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownIdDeclaration guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownId guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownUrl guifg=#FF628C ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi markdownCodeDelimiter guifg=#0088FF ctermfg=33 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NeomakeErrorMsg guifg=#FF0000 ctermfg=9 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NeomakeWarningMsg guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NERDTreeHelp guifg=#345FA8 ctermfg=61 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NERDTreeUp guifg=#345FA8 ctermfg=61 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NERDTreeOpenable guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NERDTreeClosable guifg=#FF0000 ctermfg=9 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NERDTreeDir guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link NERDTreeDirSlash Ignore
hi NERDTreeExecFile guifg=#967EFB ctermfg=105 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link objcClass Type
hi link cocoaClass objcClass
hi link objcSubclass objcClass
hi link objcSuperclass objcClass
hi link objcDirective rubyClass
hi link objcStatement Constant
hi link cocoaFunction Function
hi link objcMethodName Identifier
hi link objcMethodArg Normal
hi link objcMessageName Identifier
hi link phpFunctions Function
hi link phpSuperglobal Identifier
hi link phpQuoteSingle StringDelimiter
hi link phpQuoteDouble StringDelimiter
hi link phpBoolean Constant
hi link phpNull Constant
hi link phpArrayPair Operator
hi link phpOperator Normal
hi link phpRelation Normal
hi link phpVarSelector Identifier
hi link pythonOperator Statement
hi qfLineNr guifg=#0088FF ctermfg=33 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyBlockParameterList guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyInterpolation guifg=#9EFF80 ctermfg=156 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyClass guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link rubyModule rubyClass
hi link rubyGlobalVariable rubyInstanceVariable
hi rubyBlockParameter guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyInstanceVariable guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubySymbol guifg=#FF628C ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyAccess guifg=#967EFB ctermfg=105 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyInterpolationDelimiter guifg=#FFFFFF ctermfg=15 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpDelimiter guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpEscape guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpQuantifier guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpAnchor guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpCharClass guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexpSpecial guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi rubyRegexp guifg=#88FF88 ctermfg=120 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link vimOper Normal
hi xmlTag guifg=#CCCCCC ctermfg=252 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi xmlTagName guifg=#80FCFF ctermfg=123 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi xmlEndTag guifg=#80FCFF ctermfg=123 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi xmlAttrib guifg=#FF9A00 ctermfg=208 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi xmlString guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi xmlEqual guifg=#FFC600 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE


" ===================================
" Generated by Estilo 1.3.2
" https://github.com/jacoborus/estilo
" ===================================
