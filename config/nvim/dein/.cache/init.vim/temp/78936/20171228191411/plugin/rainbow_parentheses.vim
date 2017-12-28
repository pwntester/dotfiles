"==============================================================================
"  Description: Rainbow colors for parentheses, based on rainbow_parenthsis.vim
"               by Martin Krischik and others.
"==============================================================================

command! -bang -nargs=? -bar RainbowParentheses
  \  if empty('<bang>')
  \|   call rainbow_parentheses#activate()
  \| elseif <q-args> == '!'
  \|   call rainbow_parentheses#toggle()
  \| else
  \|   call rainbow_parentheses#deactivate()
  \| endif

