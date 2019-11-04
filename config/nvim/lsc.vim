" use FZF for code actions
function! s:FZFCodeActionSink(actions, selected) abort
    let idx = split(a:selected, '::')[0]
    call lsc#edit#applyCodeAction(a:actions[idx])
endfunction

function! s:FZFSelectAction(actions) abort
    let l:items = map(deepcopy(a:actions), {idx, item -> string(idx).'::'.item.title})
    call fzf#run(fzf#wrap({
        \ 'source': l:items,
        \ 'sink': function('<SID>FZFCodeActionSink', [a:actions]),
        \ 'down': '~40%',
        \ 'options': '+m --with-nth 2.. -d "::"',
        \ }))
    return v:true
endfunction

nnoremap ga :call lsc#edit#findCodeActions(function('<SID>FZFSelectAction'))<Return>

" define signs
call sign_define("vim-lsc-error", {"text" : "x", "texthl" : "lscSignDiagnosticError"})
call sign_define("vim-lsc-warning", {"text" : "x", "texthl" : "lscSignDiagnosticWarning"})

" virtual text namespace
let s:namespace_id = nvim_create_namespace("vim-lsc")

autocmd User LSCDiagnosticsChange call lightline#update()
autocmd User LSCDiagnosticsChange call s:updateDiagnosticVisuals()
autocmd WinEnter,BufEnter * nested if lsc#server#status(&filetype) == "running" | call s:updateDiagnosticVisuals() | endif
autocmd WinEnter,BufEnter {} nested if lsc#server#status(&filetype) == "running" | call s:updateDiagnosticVisuals() | endif
 
" improve LSC diagnostic visualizations
function! s:updateDiagnosticVisuals() abort
    let diagnostics = []
    for buf_id in nvim_list_bufs()
        if nvim_buf_is_loaded(buf_id)
            let loclistItems = getloclist(buf_id)
            if len(loclistItems) > 0
                call filter(loclistItems, {index, dict -> dict['type'] == 'E' || dict['type'] == 'W'})
                for item in loclistItems 
                    let diagnostic = {}
                    let diagnostic['text'] = item['text']
                    let diagnostic['lnum'] = item['lnum'] - 1
                    let diagnostic['type'] = item['type']
                    let diagnostic['bufnr'] = item['bufnr']
                    call add(diagnostics, diagnostic)
                endfor
            endif
        endif
    endfor

    call s:setVirtualText(diagnostics)
    call s:setSigns(diagnostics)
endfunction

function! s:setVirtualText(diagnostics) abort
    if !exists('*nvim_buf_set_virtual_text')
        return
    endif

    " clear previous virtual texts
    let buf_id = nvim_get_current_buf()
    let line_count = nvim_buf_line_count(buf_id) 
    call nvim_buf_clear_namespace(buf_id, s:namespace_id, 0, line_count)

    " add virtual texts
    for diagnostic in a:diagnostics
        if diagnostic['bufnr'] != buf_id
            continue
        endif
        let available_space = winwidth('%') - strwidth(getline(diagnostic['lnum']+1)) - 8
        let text = diagnostic['text']
        if strwidth(text) < l:available_space
            let text = repeat(" ", available_space - strwidth(text)).text
        endif
        let hl_group = 'Normal'
        if diagnostic['type'] == 'E'
            let hl_group = 'lscVTDiagnosticError'
        elseif diagnostic['type'] == 'W'
            let hl_group = 'lscVTDiagnosticWarning'
        endif
        call nvim_buf_set_virtual_text(diagnostic['bufnr'], s:namespace_id, diagnostic['lnum'], [[text, hl_group]], {})
    endfor
endfunction

function! s:setSigns(diagnostics) abort

    " clear previous virtual texts
    let buf_id = nvim_get_current_buf()
    call sign_unplace('vim-lsc', {'buffer' : buf_id})

    " add signs
    for diagnostic in a:diagnostics
        if diagnostic['bufnr'] != buf_id
            continue
        endif
        if diagnostic['type'] == 'E'
            let sign = 'vim-lsc-error'
        elseif diagnostic['type'] == 'W'
            let sign = 'vim-lsc-warning'
        else 
            return
        endif
        call sign_place(1, 'vim-lsc', sign, diagnostic['bufnr'], {'lnum' : diagnostic['lnum'] + 1})
    endfor
endfunction

" disable LSC for large files
function! s:disableLSC() abort
    if index(['go', 'java', 'javascript', 'python', 'fortifyrulepack'], &filetype) > -1
        call lsc#server#disable()
    endif
endfunction
autocmd BufEnter * nested if getfsize(@%) > 1000000 | call s:disableLSC() | endif

" eclipse.jdt.ls response hooks to make it LSP compliant
function! s:fixEdits(actions) abort
    return map(a:actions, function('<SID>fixEdit'))
endfunction

function! s:fixEdit(idx, maybeEdit) abort
    if !has_key(a:maybeEdit, 'command') || a:maybeEdit.command.command !=# 'java.apply.workspaceEdit'
        return a:maybeEdit
    endif
    return {'edit': a:maybeEdit.command.arguments[0], 'title': a:maybeEdit.command.title}
endfunction

" LSC config
let g:lsc_mute_notifications   = v:true
let g:lsc_enable_autocomplete  = v:false
let g:lsc_enable_diagnostics   = v:true
let g:lsc_reference_highlights = v:true
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'GoToDefinitionSplit': ['<C-W>]', '<C-W><C-]>'],
    \ 'FindReferences': 'gr',
    \ 'NextReference': 'gn',
    \ 'PreviousReference': 'gp',
    \ 'FindImplementations': 'gi',
    \ 'FindCodeActions': 'gA',
    \ 'Rename': 'gR',
    \ 'ShowHover': 'gh',
    \ 'DocumentSymbol': 'DS',
    \ 'WorkspaceSymbol': 'WS',
    \ 'SignatureHelp': 'gs',
    \ 'Completion': '',
    \}
let g:lsc_server_commands = {
    \ 'fortifyrulepack': {
    \   'command': '~/bin/fls', 
    \ },
    \ 'java': {
    \   'command': '~/bin/jdtls',
    \   'response_hooks': {
    \       'textDocument/codeAction': function('<SID>fixEdits'),
    \   },
    \ },
    \ 'javascript': {
    \   'command': 'typescript-language-server --stdio',
    \ },
    \ 'go': {
    \   'command': 'gopls -logfile /tmp/gopls.log serve',
    \ },
    \ 'python': {
    \   'command': 'pyls',
    \ }
    \}
