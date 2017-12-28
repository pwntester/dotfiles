scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif

syntax match FortifyCategoryMapping  '^\zs.*:\ze.*'

"highlight default link FortifyCategoryMapping  Title

let b:current_syntax = "fortifycategory"


