local M = {}

-- pip install black
M.black = {
  formatCommand = "black --fast -",
  formatStdin = true,
}

-- npm install eslint
M.eslint = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {
    "%f(%l,%c): %tarning %m",
    "%f(%l,%c): %rror %m",
  },
  lintSource = "eslint",
}
-- pip install flake8
M.flake8 = {
  lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
  lintSource = "flake8",
}
M.govet = {
  lintCommand = "go vet",
  lintIgnoreExitCode = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintSource = "go vet",
}
M.goimports = {
  formatCommand = "goimports",
  formatStdin = true,
}
-- pip install isort
M.isort = {
  formatCommand = "isort --stdout --profile black -",
  formatStdin = true,
}
-- luarocks install luacheck
M.luacheck = {
  lintCommand = "luacheck --globals vim --codes --formatter plain --std luajit --filename ${INPUT} -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintSource = "luacheck",
}
-- go get -u github.com/client9/misspell/cmd/misspell
M.goget = {
  lintCommand = "misspell",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintSource = "misspell",
}
-- pip install mypy
M.mypy = {
  lintCommand = "mypy --show-column-numbers --ignore-missing-imports --show-error-codes",
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
  lintSource = "mypy",
}
-- npm install prettier
M.prettier = {
  formatCommand = [[$([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier") --stdin-filepath ${INPUT} ${--config-precedence:configPrecedence} ${--tab-width:tabWidth} ${--single-quote:singleQuote} ${--trailing-comma:trailingComma}]],
  formatStdin = true,
}
-- brew install shellcheck
M.shellcheck = {
  lintCommand = "shellcheck -f gcc -x -",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
  lintSource = "shellcheck",
}
-- brew install shfmt
M.shfmt = {
  formatCommand = "shfmt ${-i:tabWidth}",
}
-- go install honnef.co/go/tools/cmd/staticcheck@latest
M.staticcheck = {
  lintCommand = "staticcheck",
  lintIgnoreExitCode = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintSource = "staticcheck",
}
-- brew install stylua
M.stylua = {
  formatCommand = "stylua --column-width 120 --line-endings Unix --indent-type Spaces --indent-width 2 --quote-style AutoPreferDouble --call-parentheses None -s --stdin-filepath ${INPUT} -",
  formatStdin = true
}

return M
