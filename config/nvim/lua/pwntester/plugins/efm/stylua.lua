# brew install stylua
return {
  formatCommand = "stylua --column_width 120 --line_endings Unix --indent_type Spaces --indent_width 2 --quote_style AutoPreferDouble --no_call_parentheses true -s --stdin-filepath ${INPUT} -",
  formatStdin = true
}
