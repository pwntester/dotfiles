let g:dirvish_mode = ':sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _'

" add ../ at the top
call nvim_buf_set_lines(0, 0, 0, 0, [expand('%')."../"]) 

" map .. to -
nnoremap <silent><buffer> .. :Dirvish ..<CR> 

" map `<CR>` to open in previous window.
nnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish('')<CR>" 
xnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish('')<CR>" 

" map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<CR>:setl cole=3<CR> 

" actions
nnoremap <buffer> t :silent !touch %
nnoremap <buffer> r :silent !rm %
nnoremap <buffer> m :silent !mv %

" win options
call nvim_win_set_option(0, 'winfixwidth', v:true) 
call nvim_win_set_option(0, 'number', v:false) 
call nvim_win_set_option(0, 'relativenumber', v:false) 
call nvim_win_set_option(0, 'conceallevel', 2) 
call nvim_win_set_option(0, 'concealcursor', 'n') 
call nvim_win_set_option(0, 'signcolumn', 'yes') 

" reload dirvish after shell commands
au ShellCmdPost <silent><buffer> Dirvish %
