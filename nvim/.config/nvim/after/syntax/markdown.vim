unlet b:current_syntax

syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml


" markdownWikiLink is a new region
syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends
" markdownLinkText is copied from runtime files with 'concealends' appended
syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
" markdownLink is copied from runtime files with 'conceal' appended
syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal


"syn region wikiLinkText matchgroup=markdownLinkTextDelimiter start=/\[\[/ end=/\]\]/ oneline
"syn match markdownTaskTODO  ' ' containedin=markdownTask
"syn match markdownTaskDONE 'x' containedin=markdownTask
"syn region markdownTask matchgroup=markdownTaskDelimiter start="\[[^\[]" end="\][^\(]" oneline contains=markdownTaskDONE,markdownTaskTODO
syn match markdownTaskTODO /\[ \]/
syn match markdownTaskDONE /\[x\]/
hi def link markdownTaskDONE markdownTaskDelimiter
hi def link markdownTaskTODO markdownTaskDelimiter
