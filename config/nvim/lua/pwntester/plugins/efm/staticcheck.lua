# go install honnef.co/go/tools/cmd/staticcheck@latest
return {
    lintCommand = "staticcheck",
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintSource = "staticcheck",
}
