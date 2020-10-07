au InsertLeave <buffer> lua require'markdown'.markdownBlocks() 
au BufEnter <buffer> lua require'markdown'.markdownBlocks() 
au BufWritePost <buffer> lua require'markdown'.markdownBlocks() 
au CursorMoved <buffer> lua require'markdown'.markdownBlocks() 

if exists('g:mkdx#settings') | let b:pear_tree_map_special_keys = 0 | endif 
setlocal conceallevel=2 
setlocal concealcursor=c 
setlocal signcolumn=no 
setlocal spell complete+=kspell 
nnoremap <buffer> <leader>p lua require'markdown'.pasteImage('images'<CR> 
nnoremap <buffer> <leader>l lua require'markdown'.pasteLink()<CR> 

