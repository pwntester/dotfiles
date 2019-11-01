" ================ AUTOCOMMANDS ==================== {{{
augroup windows
    autocmd!
    " enable buffer cycling on non-special buffers
    autocmd WinEnter,BufEnter * nested call s:bufferSettings()
    autocmd WinEnter,BufEnter {} nested call s:bufferSettings()
    " prevent opening files on windows with special buffers 
    autocmd BufLeave * call s:trackSpecialBuffersOnBufLeave() 
    autocmd BufEnter * call s:trackSpecialBuffersOnBufEnter()
augroup END

" ================ GLOBALS ======================== {{{
let g:special_buffers = ['help', 'fortifytestpane', 'fortifyauditpane', 'defx', 'qf', 'vim-plug', 'fzf', 'magit', 'goterm']
let g:previous_buffer = 0
let g:is_previous_buffer_special = 0

" ================ FUNCTIONS ======================== {{{
function! s:bufferSettings() abort
    if index(g:special_buffers, &filetype) == -1
        " cycle through buffers on regular buffers
        nnoremap <silent><buffer><S-l> :bnext<Return>
        nnoremap <silent><buffer><S-h> :bprevious<Return>
    else
        " disable buffer cycling on special buffers
        nnoremap <silent><buffer><S-l> <Nop>
        nnoremap <silent><buffer><S-h> <Nop>
    endif
endfunction

function! s:trackSpecialBuffersOnBufLeave() abort
    let bufnum = bufnr('%')
    let g:previous_buffer = bufnum
    if index(g:special_buffers, &filetype) > -1
        let g:is_previous_buffer_special = 1 
        "call Log('Leaving special buffer '.bufnum)
    else
        let g:is_previous_buffer_special = 0 
        "call Log('Leaving regular buffer '.bufnum)
    endif
endfunction

function! s:trackSpecialBuffersOnBufEnter()
    let bufnum = bufnr('%')
    let bufname = bufname('%')
    let buftype = &filetype

    if index(g:special_buffers, buftype) > -1
        "call Log('Entering special buffer '.bufnum.' from '.g:previous_buffer)
    else
        "call Log('Entering regular buffer '.bufnum.' from '.g:previous_buffer)
    endif

    if (bufname == "" && buftype == "") || bufname =~ '^term:' || index(g:special_buffers, buftype) > -1 
        " Neither the bufname, mode or type for terminal buffer is set at
        " BufEnter. It is actually set at TermOpen, but that does not work
        " for us. We need to consider that an unnammed buffer is a terminal
        " buffer
        "call Log('    Skipping special, unnammed, untyped buffer')
        return
    elseif g:is_previous_buffer_special && bufexists(g:previous_buffer)
        "call Log('   Comming from special buffer ' . g:previous_buffer)

        " get special buffer back to this window
        if bufexists(g:previous_buffer)
            call nvim_win_set_buf(win_getid(), g:previous_buffer)
        endif

        " found a window with a non-special buffer
        for w in nvim_list_wins()
            if index(g:special_buffers, nvim_buf_get_option(nvim_win_get_buf(w), 'filetype')) == -1
                " set current window as inactive
                call nvim_win_set_option(win_getid(), 'cursorline', v:false)
                call nvim_win_set_option(win_getid(), 'winhighlight', '')
                " move to non-special window
                call nvim_set_current_win(w)
                break
            endif
        endfor
        
        " open new buffer
        call nvim_win_set_buf(win_getid(), bufnum)
    endif
endfunction

