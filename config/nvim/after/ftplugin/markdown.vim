augroup markdown 
  au!
  au BufEnter <buffer> syntax sync fromstart 
  au BufEnter <buffer> lua require("pwntester.markdown").markdownBlocks() 
  au TextChanged <buffer> lua require("pwntester.markdown").markdownBlocks() 
  au TextChangedI <buffer> lua require("pwntester.markdown").markdownBlocks() 
augroup END

sign define codeblock linehl=markdownCodeBlock

setlocal conceallevel=2 
setlocal concealcursor=c 
setlocal nonumber
setlocal norelativenumber
setlocal spell complete+=kspell 
setlocal iskeyword+=-
setlocal iskeyword+=@-@
setlocal wrap
setlocal breakindent
setlocal breakindentopt=min:5,list:-1
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:'

if &ft == 'octo'
  setlocal foldcolumn=0
  setlocal signcolumn=yes:1
else
  setlocal foldcolumn=9
  setlocal signcolumn=yes:9
endif

