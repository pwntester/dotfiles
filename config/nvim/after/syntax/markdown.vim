syn region wikiLinkText matchgroup=markdownLinkTextDelimiter start=/\[\[/ end=/\]\]/ oneline
"syn match markdownTaskTODO  ' ' containedin=markdownTask
"syn match markdownTaskDONE 'x' containedin=markdownTask
"syn region markdownTask matchgroup=markdownTaskDelimiter start="\[[^\[]" end="\][^\(]" oneline contains=markdownTaskDONE,markdownTaskTODO
syn match markdownTaskTODO /\[ \]/
syn match markdownTaskDONE /\[x\]/
hi def link markdownTaskDONE markdownTaskDelimiter
hi def link markdownTaskTODO markdownTaskDelimiter
