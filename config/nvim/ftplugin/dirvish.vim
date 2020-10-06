call sign_define('dirvish-indent', { 'text': ' '})
let g:dirvish_mode = ':sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _'

" add ../ at the top
call nvim_buf_set_lines(0, 0, 0, 0, [expand('%')."../"]) 

" indent text by adding a transparent sign
sign place 1 line=1 name=dirvish-indent 

" map `<CR>` to open in previous window.
nnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish()<CR>" 
xnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>call ToggleDirvish()<CR>" 

" map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<CR>:setl cole=3<CR> 

" fix dirvish win width
call nvim_win_set_option(0, 'winfixwidth', v:true) 

" do not show line numbers
call nvim_win_set_option(0, 'number', v:false) 

" status line
lua statusline.active() 

" map .. to -
nnoremap <silent><buffer> .. :Dirvish ..<CR> 

call nvim_win_set_option(0, 'cole', 2) 
call nvim_win_set_option(0, 'cocu', 'n') 

" reload dirvish after shell commands
au ShellCmdPost <buffer> Dirvish %
