" use FZF for code actions
function! s:FZFExecuteAction(actions, OnSelection, chosen) abort
    let idx = split(a:chosen, '::')[0]
    call a:OnSelection(a:actions[idx])
endfunction

function! s:FZFActionMenu(actions, OnSelection) abort
    let l:options = map(deepcopy(a:actions), {idx, item -> string(idx).'::'.item.title})
    call fzf#run(fzf#wrap({
        \ 'source': l:options,
        \ 'sink': function('<SID>FZFExecuteAction', [a:actions, a:OnSelection]),
        \ 'down': '~40%',
        \ 'options': '+m --with-nth 2.. -d "::"',
        \ }))
endfunction
let g:LSC_action_menu = function('<SID>FZFActionMenu')

" define signs
call sign_define("vim-lsc-error", {"text" : "x", "texthl" : "lscSignDiagnosticError"})
call sign_define("vim-lsc-warning", {"text" : "x", "texthl" : "lscSignDiagnosticWarning"})

" virtual text namespace
let s:namespace_id = nvim_create_namespace("vim-lsc")

" update diagnostic visualizations
function! s:updateDiagnosticVisuals() abort
    let buf_id = nvim_get_current_buf()
    let file_path = nvim_buf_get_name(buf_id)
    let diagnostics = lsc#diagnostics#forFile(file_path).ListItems()
    call s:setVirtualText(buf_id, diagnostics)
    call s:setSigns(buf_id, diagnostics)
endfunction

function! s:setVirtualText(buf_id, diagnostics) abort

    " clear previous virtual texts
    call nvim_buf_clear_namespace(a:buf_id, s:namespace_id, 0, -1)

    " add virtual texts
    for diagnostic in a:diagnostics
        let available_space = winwidth('%') - strwidth(getline(l:diagnostic['lnum'])) - 8
        let text = strwidth(l:diagnostic['text']) < l:available_space ?  repeat(" ", l:available_space - strwidth(l:diagnostic['text'])).l:diagnostic['text'] : l:diagnostic['text']
        let hl_group = l:diagnostic['type'] == 'E' ? 'lscVTDiagnosticError' : 'lscVTDiagnosticWarning'
        call nvim_buf_set_virtual_text(l:diagnostic['bufnr'], s:namespace_id, l:diagnostic['lnum']-1, [[l:text, l:hl_group]], {})
    endfor
endfunction

function! s:setSigns(buf_id, diagnostics) abort

    " clear previous virtual texts
    call sign_unplace('vim-lsc', {'buffer' : a:buf_id})

    " add signs
    for diagnostic in a:diagnostics
        if l:diagnostic['type'] == 'E'
            let sign = 'vim-lsc-error'
        elseif l:diagnostic['type'] == 'W'
            let sign = 'vim-lsc-warning'
        else 
            return
        endif
        call sign_place(1, 'vim-lsc', l:sign, l:diagnostic['bufnr'], {'lnum' : l:diagnostic['lnum']})
    endfor
endfunction

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

" autocommands
autocmd BufEnter * if has_key(g:lsc_server_commands, &filetype) && getfsize(@%) > 1000000 | call lsc#server#disable() | endif
autocmd BufEnter * if has_key(g:lsc_server_commands, &filetype) && getfsize(@%) < 1000000 | call s:updateDiagnosticVisuals() | endif
autocmd User LSCDiagnosticsChange call s:updateDiagnosticVisuals()
autocmd User LSCDiagnosticsChange call lightline#update()
 
" config
let g:lsc_mute_notifications   = v:true
let g:lsc_enable_autocomplete  = v:false
let g:lsc_enable_diagnostics   = v:true
let g:lsc_reference_highlights = v:true
let g:lsc_auto_map = {
    \   'GoToDefinition': '<leader>ld',
    \   'FindReferences': '<leader>lr',
    \   'NextReference': '<leader>ln',
    \   'PreviousReference': '<leader>lp',
    \   'FindImplementations': '<leader>li',
    \   'FindCodeActions': '<leader>la',
    \   'Rename': '<leader>lR',
    \   'ShowHover': '<leader>lh',
    \   'DocumentSymbol': '<leader>lds',
    \   'WorkspaceSymbol': '<leader>lws',
    \   'SignatureHelp': '<leader>ls',
    \   'Completion': ''
    \}
let g:lsc_server_commands = {
    \   'fortifyrulepack': {
    \       'command': 'fls'
    \   },
    \   'java': {
    \       'command': 'jdtls',
    \       'response_hooks': {
    \           'textDocument/codeAction': function('<SID>fixEdits')
    \       },
    \   },
    \   'javascript': {
    \       'command': 'typescript-language-server --stdio'
    \   },
    \   'go': {
    \       'command': 'gopls -logfile /tmp/gopls.log serve'
    \   },
    \   'python': {
    \       'command': 'pyls'
    \   }
    \}
