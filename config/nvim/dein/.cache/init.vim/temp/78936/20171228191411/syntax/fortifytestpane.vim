scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif

syntax match FortifyTestPaneCmd     '^\zs\(Found\|Running\|Looking for RuleTests\|Build ID\|FPR File\|Memory Settings\|Scan Settings\|Project Base Path\):\ze.*'
syntax match FortifyTestPanePassed  '\zs\d\+\ze\spassed'
syntax match FortifyTestPaneFailed  '\zs\d\+\ze\sfailures'
syntax match FortifyTestPaneBug     '\zs(Bug\s\d\+)\ze'
syntax match FortifyTestPaneFile    '^\zs[0-9a-zA-Z _\-./]\+:\d\+\ze'

" highlight default link FortifyTestPaneCmd     Comment
" highlight default link FortifyTestPaneFile    Title
" highlight default FortifyTestPanePassed guifg=Green   ctermfg=Green
" highlight default FortifyTestPaneFailed guifg=Red     ctermfg=Red
highlight default FortifyTestPaneBug guifg=yellow ctermfg=yellow

let b:current_syntax = "fortifytestpane"


