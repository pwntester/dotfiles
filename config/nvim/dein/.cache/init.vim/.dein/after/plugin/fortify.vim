" PLUGIN Configuration

" neomake configuration
if exists(":Neomake")
  let g:neomake_fortifyrulepack_rulepacklinter_maker = {
    \ 'errorformat': '%E%t:%f:%l:%c: %m',
    \ 'exe': g:fortify_pluginpath."/rplugin/python3/fortify/linter.py"
  \}
  let g:neomake_fortifyrulepack_enabled_makers = ["rulepacklinter"]
endif

" vim-repeat and <leader> mappings
if exists('g:fortify_no_maps')
  if !g:fortify_no_maps
    try
      " Calling a vim-repeat function since it uses autoload
      call repeat#set()
    catch
    endtry
    if exists("g:loaded_repeat")
      nnoremap <silent> <Plug>CloneRuleMap :CloneRule<CR> :call repeat#set("\<Plug>CloneRuleMap")<CR>
      nnoremap <silent> <Plug>CommentRuleMap :CommentRule<CR> :call repeat#set("\<Plug>CommentRuleMap")<CR>
      nnoremap <silent> <Plug>IndentRuleMap :IndentRule<CR> :call repeat#set("\<Plug>IndentRuleMap")<CR>
      nnoremap <silent> <Plug>PatternValueMap :PatternValue<CR> :call repeat#set("\<Plug>PatternValueMap")<CR>
      nnoremap <silent> <Plug>ToggleRuleIDMap :ToggleRuleID<CR> :call repeat#set("\<Plug>ToggleRuleIDMap")<CR>
      nmap <leader>fk <Plug>CloneRuleMap
      nmap <leader>fc <Plug>CommentRuleMap
      nmap <leader>fi <Plug>IndentRuleMap
      nmap <leader>fp <Plug>PatternValueMap
      nmap <leader>ft <Plug>ToggleRuleIDMap
    else
      nmap <leader>fk :CloneRule<CR>
      nmap <leader>fc :CommentRule<CR>
      nmap <leader>fi :IndentRule<CR>
      nmap <leader>fp :PatternValue<CR>
      nmap <leader>ft :ToggleRuleID<CR>
    endif
    nnoremap <leader>fn :ShowNST<CR>
    nnoremap <leader>fo :OpenFPR<CR>
  endif
endif


