runtime! ftplugin/fortifyauditpane.vim
scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif


syntax match FortifyAuditPaneFoldIcon                      '[▶▼]'
syntax match FortifyAuditPaneAltFoldIcon                   '[+-]'
syntax match FortifyAuditPaneInCallIcon                    '→'
syntax match FortifyAuditPaneOutCallIcon                   '⟵'
syntax match FortifyAuditPaneReadGlobalIcon                '⤝'
syntax match FortifyAuditPaneReturnIcon                    '↵'
syntax match FortifyAuditPaneAssignGlobalIcon              'ⓖ'
syntax match FortifyAuditPaneInOutCallIcon                 '↔'
syntax match FortifyAuditPaneAssignIcon                    '≔'
syntax match FortifyAuditPaneBranchTakenIcon               'ᛦ'
syntax match FortifyAuditPaneBranchNotTakenIcon            'ᚼ'
syntax match FortifyAuditPaneDefaultIcon                   '⦿'
syntax match FortifyAuditPaneJumpIcon                      '⤸'
syntax match FortifyAuditPaneRuleIcon                      '\*$'

syntax match FortifyAuditPaneFile                          '\s\zs[^:▶▼→↔≔⤝⟵↵ⓖᛦᚼ⦿⤸ ]\+:\d\+\ze\s-'

syntax match FortifyAuditPaneHelp                          '^".*' contains=FortifyAuditPaneHelpKey,FortifyAuditPaneHelpTitle
syntax match FortifyAuditPaneHelpKey                       '" \zs.*\ze:' contained
syntax match FortifyAuditPaneHelpTitle                     '" \zs-\+ \w\+ -\+' contained

syntax match FortifyAuditPaneInfo                          '^\a.*:\s\ze.*'
syntax match FortifyAuditPaneTraces                        '^\s\+Trace:\s\ze.*'
syntax match FortifyAuditPaneExternalEntry                 '^\s\+\zs>.*'
syntax match FortifyAuditPaneSeparator                     '\s-\s'
syntax match FortifyAuditPaneCategoryCount                 '\a*\s\zs\[.*\]\ze$' contains=FortifyAuditPaneDigit
syntax match FortifyAuditPaneDigit                         '\d\+' contained
syntax match FortifyAuditPaneBracket                       '^\s\+\[.*\]' contains=FortifyAuditPaneFact
syntax match FortifyAuditPaneFact                          '[^\[\]]*' contained

syntax match FortifyAuditPaneIssue                         '[+-]\s\zs[a-zA-Z_\-.]\+:\d\+\ze'

" highlight default link FortifyAuditPaneHelp                Comment
" highlight default link FortifyAuditPaneHelpKey             Identifier
" highlight default link FortifyAuditPaneHelpTitle           PreProc
" highlight default link FortifyAuditPaneCategoryCount       Title
" highlight default link FortifyAuditPaneDigit               Text
" highlight default link FortifyAuditPaneInfo                Title
" highlight default link FortifyAuditPaneTraces              Title
" highlight default link FortifyAuditPaneIssue               Statement
" highlight default link FortifyAuditPaneFoldIcon            Title
" highlight default link FortifyAuditPaneAltFoldIcon         Keyword
" highlight default link FortifyAuditPaneBracket             Title
" highlight default link FortifyAuditPaneRule                Title
" highlight default link FortifyAuditPaneFact                Type
"
" highlight default FortifyAuditPaneGreen    guifg=Green   ctermfg=Green
" highlight default FortifyAuditPaneGrey     guifg=Grey    ctermfg=Grey
" highlight default FortifyAuditPaneBlue     guifg=Blue    ctermfg=Blue
" highlight default FortifyAuditPaneRed      guifg=Red     ctermfg=Red
" highlight default FortifyAuditPaneYellow   guifg=Yellow  ctermfg=Yellow
" highlight default FortifyAuditPaneOrange   guifg=#ffaf00 ctermfg=214
"
" highlight default link FortifyAuditPaneInCallIcon          FortifyAuditPaneGreen
" highlight default link FortifyAuditPaneInOutCallIcon       FortifyAuditPaneBlue
" highlight default link FortifyAuditPaneOutCallIcon         FortifyAuditPaneRed
" highlight default link FortifyAuditPaneReadGlobalIcon      FortifyAuditPaneOrange
" highlight default link FortifyAuditPaneAssignGlobalIcon    FortifyAuditPaneOrange
" highlight default link FortifyAuditPaneAssignIcon          FortifyAuditPaneOrange
" highlight default link FortifyAuditPaneReturnIcon          FortifyAuditPaneYellow
" highlight default link FortifyAuditPaneExternalEntry       FortifyAuditPaneYellow
" highlight default link FortifyAuditPaneSeparator           FortifyAuditPaneYellow
" highlight default link FortifyAuditPaneRuleIcon            FortifyAuditPaneYellow
" highlight default link FortifyAuditPaneFile                FortifyAuditPaneGrey
" highlight default link FortifyAuditPaneBranchTakenIcon     FortifyAuditPaneGreen
" highlight default link FortifyAuditPaneBranchNotTakenIcon  FortifyAuditPaneRed
" highlight default link FortifyAuditPaneDefaultIcon         FortifyAuditPaneBlue
" highlight default link FortifyAuditPaneJumpIcon            FortifyAuditPaneYellow


"let b:current_syntax = "fortifyauditpane"

syntax match FortifyAuditPaneFriorityLow "@.*@" contains=delimLow
syntax match FortifyAuditPaneFriorityMedium "=.*=" contains=delimMedium
syntax match FortifyAuditPaneFriorityHigh "%.*%" contains=delimHigh
syntax match FortifyAuditPaneFriorityCritical "#.*#" contains=delimCritical
syntax match delimLow contained '@' conceal
syntax match delimMedium contained '=' conceal
syntax match delimHigh contained '%' conceal
syntax match delimCritical contained '#' conceal
" highlight FortifyAuditPaneFriorityLow ctermfg=190
" highlight FortifyAuditPaneFriorityMedium ctermfg=178
" highlight FortifyAuditPaneFriorityHigh ctermfg=166
" highlight FortifyAuditPaneFriorityCritical ctermfg=160

set concealcursor=niv
set conceallevel=2
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
