au BufEnter <buffer> lua require('markdown').markdownBlocks() 
au BufEnter <buffer> syntax sync fromstart 
au TextChanged <buffer> lua require'markdown'.markdownBlocks() 
au TextChangedI <buffer> lua require'markdown'.markdownBlocks() 

sign define codeblock linehl=markdownCodeBlock

setlocal conceallevel=2 
setlocal concealcursor=c 
setlocal nonumber
setlocal norelativenumber
setlocal spell complete+=kspell 
setlocal iskeyword+=-
setlocal iskeyword+=@-@
setlocal breakindent
setlocal wrap
setlocal breakindentopt=min:5,list:-1
setlocal linebreak list&vim listchars&vim
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:'

"silent! execute "Gitsigns toggle_signs"

"nnoremap <buffer> <leader>p :lua require'markdown'.pasteImage('images')<CR> 
"nnoremap <buffer> <leader>p :PasteImg<CR> 

if &ft != 'octo'
  setlocal foldcolumn=9
  setlocal signcolumn=yes:9
else
  setlocal foldcolumn=0
  setlocal signcolumn=yes:1
endif

