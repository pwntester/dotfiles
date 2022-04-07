# go get -u github.com/client9/misspell/cmd/misspell
return {
    lintCommand = "misspell",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "misspell",
}
