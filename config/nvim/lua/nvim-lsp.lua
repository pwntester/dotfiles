severity_highlights = {}
severity_highlights[1] = 'LspDiagnosticsError'
severity_highlights[2] = 'LspDiagnosticsWarning'

underline_highlight_name = "LspDiagnosticsUnderline"

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L560
validate = vim.validate
all_buffer_diagnostics = {}
diagnostic_ns = vim.api.nvim_create_namespace("vim_lsp_diagnostics")

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L425
function highlight_range(bufnr, ns, hiname, start, finish)
    if start[1] == finish[1] then
        vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2], finish[2])
    else
        vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2], -1)
        for line = start[1] + 1, finish[1] - 1 do
            vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, line, 0, -1)
        end
        vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, finish[1], 0, finish[2])
    end
end

-- copied from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua
function set_lines(lines, A, B, new_lines)
    -- 0-indexing to 1-indexing
    local i_0 = A[1] + 1
    local i_n = B[1] + 1
    if not (i_0 >= 1 and i_0 <= #lines and i_n >= 1 and i_n <= #lines) then
        error("Invalid range: "..vim.inspect{A = A; B = B; #lines, new_lines})
    end
    local prefix = ""
    local suffix = lines[i_n]:sub(B[2]+1)
    if A[2] > 0 then
        prefix = lines[i_0]:sub(1, A[2])
    end
    local n = i_n - i_0 + 1
    if n ~= #new_lines then
        for _ = 1, n - #new_lines do table.remove(lines, i_0) end
        for _ = 1, #new_lines - n do table.insert(lines, i_0, '') end
    end
    for i = 1, #new_lines do
        lines[i - 1 + i_0] = new_lines[i]
    end
    if #suffix > 0 then
        local i = i_0 + #new_lines - 1
        lines[i] = lines[i]..suffix
    end
    if #prefix > 0 then
        lines[i_0] = prefix..lines[i_0]
    end
    return lines
end
local function sort_by_key(fn)
    return function(a,b)
        local ka, kb = fn(a), fn(b)
        assert(#ka == #kb)
        for i = 1, #ka do
            if ka[i] ~= kb[i] then
                return ka[i] < kb[i]
            end
        end
        -- every value must have been equal here, which means it's not less than.
        return false
    end
end
local edit_sort_key = sort_by_key(function(e)
    return {e.A[1], e.A[2], e.i}
end)
function apply_text_edits(text_edits, bufnr)
    if not next(text_edits) then return end
    local start_line, finish_line = math.huge, -1
    local cleaned = {}
    for i, e in ipairs(text_edits) do
        start_line = math.min(e.range.start.line, start_line)
        finish_line = math.max(e.range["end"].line, finish_line)
        -- TODO(ashkan) sanity check ranges for overlap.
        table.insert(cleaned, {
                i = i;
                A = {e.range.start.line; e.range.start.character};
                B = {e.range["end"].line; e.range["end"].character};
                lines = vim.split(e.newText, '\n', true);
            })
    end
    -- Reverse sort the orders so we can apply them without interfering with
    -- eachother. Also add i as a sort key to mimic a stable sort.
    table.sort(cleaned, edit_sort_key)
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, finish_line + 1, false)
    local fix_eol = vim.api.nvim_buf_get_option(bufnr, 'fixeol')
    local set_eol = fix_eol and vim.api.nvim_buf_line_count(bufnr) == finish_line + 1
    if set_eol and #lines[#lines] ~= 0 then
        table.insert(lines, '')
    end

    for i = #cleaned, 1, -1 do
        local e = cleaned[i]
        local A = {e.A[1] - start_line, e.A[2]}
        local B = {e.B[1] - start_line, e.B[2]}
        lines = set_lines(lines, A, B, e.lines)
    end
    if set_eol and #lines[#lines] == 0 then
        table.remove(lines)
    end
    vim.api.nvim_buf_set_lines(bufnr, start_line, finish_line + 1, false, lines)
end

-- configure client capabilities
function config_client_callback(initialize_params, config)

    -- yes we can!
    initialize_params['capabilities']['workspace'] = {
        applyEdit = true,
        workspaceEdit = {
            documentChanges = true,
            resourceOperations = { "create", "rename", "delete" },
            failureHandling = "textOnlyTransactional",
        },
        didChangeConfiguration = {
            dynamicRegistration = true
        },
        didChangeWatchedFiles = {
            dynamicRegistration = true
        },
        symbol = {
            dynamicRegistration = true,
            symbolKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            }
        },
        executeCommand = {
            dynamicRegistration = true
        },
        configuration = true,
        workspaceFolders = true
    }
    initialize_params['capabilities']['textDocument'] = {
        publishDiagnostics = {
            relatedInformation = true
        },
        completion = {
            dynamicRegistration = true,
            contextSupport = true,
            completionItem = {
                snippetSupport = true,
                commitCharactersSupport = true,
                documentationFormat = { "markdown", "plaintext" },
                deprecatedSupport = true,
                preselectSupport = true
            },
            completionItemKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            }
        },
        hover = {
            dynamicRegistration = true,
            contentFormat = { "markdown", "plaintext" }
        },
        signatureHelp = {
            dynamicRegistration = true,
            signatureInformation = {
                documentationFormat = { "markdown", "plaintext" },
                parameterInformation = {
                    labelOffsetSupport = true
                }
            }
        },
        definition = {
            dynamicRegistration = true,
            linkSupport = true
        },
        references = {
            dynamicRegistration = true
        },
        documentHighlight = {
            dynamicRegistration = true
        },
        documentSymbol = {
            dynamicRegistration = true,
            symbolKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            },
            hierarchicalDocumentSymbolSupport = true
        },
        codeAction = {
            dynamicRegistration = true,
            codeActionLiteralSupport = {
                codeActionKind = {
                    valueSet = { 
                        "",
                        "quickfix",
                        "refactor", 
                        "refactor.extract", 
                        "refactor.inline", 
                        "refactor.rewrite", 
                        "source", 
                        "source.organizeImports"
                    }
                }
            }
        },
        codeLens = {
            dynamicRegistration = true
        },
        formatting = {
            dynamicRegistration = true
        },
        rangeFormatting = {
            dynamicRegistration = true
        },
        onTypeFormatting = {
            dynamicRegistration = true
        },
        rename = {
            dynamicRegistration = true,
            prepareSupport = true
        },
        documentLink = {
            dynamicRegistration = true
        },
        typeDefinition = {
            dynamicRegistration = true,
            linkSupport = true
        },
        implementation = {
            dynamicRegistration = true,
            linkSupport = true
        },
        colorProvider = {
            dynamicRegistration = true
        },
        foldingRange = {
            dynamicRegistration = true,
            rangeLimit = 5000,
            lineFoldingOnly = true
        },
        declaration = {
            dynamicRegistration = true,
            linkSupport = true
        }
    }
end

