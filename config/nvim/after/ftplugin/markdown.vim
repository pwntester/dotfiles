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
setlocal wrap
setlocal breakindent
setlocal breakindentopt=min:5,list:-1
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:'

"nnoremap <buffer> <leader>p :lua require'markdown'.pasteImage('images')<CR> 
"nnoremap <buffer> <leader>p :PasteImg<CR> 

" Modify <CR>, o and O to continue lists
inoremap <CR> <C-R>=v:lua.markdownEnter()<CR>
nnoremap o <CMD>lua markdownO()<CR>
nnoremap O <CMD>lua markdownShiftO()<CR>

if &ft != 'octo'
  setlocal foldcolumn=9
  setlocal signcolumn=yes:9
else
  setlocal foldcolumn=0
  setlocal signcolumn=yes:1
endif

