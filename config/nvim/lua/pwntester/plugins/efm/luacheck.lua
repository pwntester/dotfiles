-- luarocks install luacheck
return {
    lintCommand = "luacheck --globals vim --codes --formatter plain --std luajit --filename ${INPUT} -",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "luacheck",
}
