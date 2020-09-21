local function setup()

  vim.fn.sign_define('dirvish-indent', {text = ' '})
  vim.g.dirvish_mode = [[ :sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _]]

  vim.cmd [[ augroup dirvish ]]
  vim.cmd [[ autocmd! ]]

  -- add ../ at the top
  vim.cmd [[ autocmd FileType dirvish call nvim_buf_set_lines(0, 0, 0, 0, [expand('%')."../"]) ]]

  -- indent text by adding a transparent sign
  vim.cmd [[ autocmd FileType dirvish sign place 1 line=1 name=dirvish-indent ]]

  -- map `<CR>` to open in previous window.
  vim.cmd [[ autocmd FileType dirvish nnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>lua require'functions'.toggleDirvish()<CR>" ]]
  vim.cmd [[ autocmd FileType dirvish xnoremap <silent><buffer><expr> <CR> getline(".") =~ "^.*\/$" ? ":<C-U>.call dirvish#open(getline('.'))<Return>" : ":<C-U>.call dirvish#open('wincmd p<BAR>edit', 0)<BAR>lua require'functions'.toggleDirvish()<CR>" ]]

  -- map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
  vim.cmd [[ autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<CR>:setl cole=3<CR> ]]

  -- reload dirvish after shell commands
  vim.cmd [[ autocmd ShellCmdPost * if nvim_buf_get_option(0, 'filetype') == 'dirvish' | Dirvish % | endif ]]

  -- fix dirvish win width
  vim.cmd [[ autocmd FileType dirvish call nvim_win_set_option(0, 'winfixwidth', v:true) ]]

  -- do not show line numbers
  vim.cmd [[ autocmd FileType dirvish call nvim_win_set_option(0, 'number', v:false) ]]

  -- status line
  vim.cmd [[ autocmd FileType dirvish lua statusline.active() ]]

  -- map .. to -
  vim.cmd [[ autocmd FileType dirvish nnoremap <silent><buffer> .. :Dirvish ..<CR> ]]

  vim.cmd [[ autocmd FileType dirvish call nvim_win_set_option(0, 'cole', 2) ]]
  vim.cmd [[ autocmd FileType dirvish call nvim_win_set_option(0, 'cocu', 'n') ]]

  vim.cmd [[ augroup END ]]
end

return {
  setup = setup;
}
