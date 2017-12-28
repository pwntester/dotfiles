" Written by Alvaro Munoz Sanchez
" Copyright (c) 2013 Alvaro Munoz Sanchez
"
" License: MIT

" author: Alvaro Munoz
"
scriptencoding utf-8

if &cp || exists('g:loaded_fortify')
    finish
endif

if !has('python') || !has('nvim')
  finish
endif

" Global Variables
let g:fortify_pluginpath = fnamemodify(resolve(expand('<sfile>:p:h')), ':h')
let g:fortify_fprpath = ''
let g:fortify_buildid = ''
let g:fortify_commandlist = []
let g:fortify_message = ""

function! s:init_var(var, value) abort
    if !exists('g:fortify_' . a:var)
        execute 'let g:fortify_' . a:var . ' = ' . string(a:value)
    endif
endfunction

function! s:setup_options() abort

    if !exists('g:fortify_auditpane_iconchars')
        if has('multi_byte') && has('unix') && &encoding == 'utf-8' &&
        \ (empty(&termencoding) || &termencoding == 'utf-8')
            let g:fortify_auditpane_iconchars = ['▶', '▼','▶', '▼']
        else
            let g:fortify_auditpane_iconchars = ['+', '-','+','-']
        endif
    endif

    call s:init_var('XCodeBuildOpts', [])
    call s:init_var('MemoryOpts', [])
    call s:init_var('AWBOpts', [])
    call s:init_var('ScanOpts', [])
    call s:init_var('TranslationOpts', [])

    let options = [
        \ ['no_maps', 0],
        \ ['CCompiler', "gcc"],
        \ ['CPPCompiler', "g++"],
        \ ['CompilerOptions', "-c"],
        \ ['JDKVersion', "1.8"],
        \ ['XCodeSDK', "macosx"],
        \ ['NSTRoot', ""],
        \ ['PythonPath', ""],
        \ ['AndroidJarPath', ""],
        \ ['DefaultJarPath', ""],
        \ ['FoldRules', 0],
        \ ['DefaultIndentation', ""],
        \ ['auditpane_width', 60],
        \ ['auditpane_pos', 'right'],
        \ ['auditpane_indent', 1],
        \ ['auditpane_zoomwidth', 1],
    \ ]

    for [opt, val] in options
        call s:init_var(opt, val)
    endfor
endfunction
call s:setup_options()


" AuditPane 
function! s:setup_auditpane_keymaps() abort
    let keymaps = [
        \ ['jump',          '<CR>'],
        \ ['preview',       'p'],
        \ ['copyruleid',    'y'],
        \ ['zoomwin',       'x'],
        \ ['info',          'i'],
        \ ['filter',        'f'],
        \ ['close',         'q'],
        \ ['nexttrace',     '<Right>'],
        \ ['previoustrace', '<Left>'],
        \ ['togglefold',    ['o', 'za']],
        \ ['openallfolds',  ['*', '<kMultiply>', 'zR']],
        \ ['closeallfolds', ['=', 'zM']],
        \ ['help',          ['<F1>', '?']],
    \ ]

    for [map, key] in keymaps
        call s:init_var('auditpane_map_' . map, key)
        unlet key
    endfor
endfunction
call s:setup_auditpane_keymaps()

" TestPane 
function! s:setup_testpane_keymaps() abort
    let keymaps = [
        \ ['jump',          '<CR>'],
        \ ['preview',       'p'],
    \ ]

    for [map, key] in keymaps
        call s:init_var('testpane_map_' . map, key)
        unlet key
    endfor
endfunction
call s:setup_testpane_keymaps()

autocmd FileType fortifytestpane setlocal nobuflisted
autocmd FileType fortifytestpane nmap <buffer><expr> <S-l> ""
autocmd FileType fortifytestpane nmap <buffer><expr> <S-h> ""
autocmd FileType fortifytestpane nmap <buffer><expr> <S-k> ""

" Rule Text Objects
onoremap <silent>ar :<C-U>call fortify#SelectRule(v:count, 'a')<CR>
vnoremap <silent>ar :<C-U>call fortify#SelectRule(v:count, 'a')<CR>
onoremap <silent>ir :<C-U>call fortify#SelectRule(v:count, 'i')<CR>
vnoremap <silent>ir :<C-U>call fortify#SelectRule(v:count, 'i')<CR>
onoremap <silent>ac :<C-U>call fortify#SelectCDATA('a')<CR>
vnoremap <silent>ac :<C-U>call fortify#SelectCDATA('a')<CR>
onoremap <silent>ic :<C-U>call fortify#SelectCDATA('i')<CR>
vnoremap <silent>ic :<C-U>call fortify#SelectCDATA('i')<CR>
onoremap <silent>af :<C-U>call fortify#SelectFunctionIdentifier('a')<CR>
vnoremap <silent>af :<C-U>call fortify#SelectFunctionIdentifier('a')<CR>
onoremap <silent>if :<C-U>call fortify#SelectFunctionIdentifier('i')<CR>
vnoremap <silent>if :<C-U>call fortify#SelectFunctionIdentifier('i')<CR>

" Rule Motions
nnoremap <silent>,r :<C-u>call fortify#MoveCursorRuleForward(v:count, mode())<CR>
onoremap <silent>,r :<C-u>call fortify#MoveCursorRuleForward(v:count, mode())<CR>
vnoremap <silent>,r :<C-u>call fortify#MoveCursorRuleForward(v:count, visualmode())<CR>
nnoremap <silent>,R :<C-u>call fortify#MoveCursorRuleBackward(v:count, mode())<CR>
onoremap <silent>,R :<C-U>call fortify#MoveCursorRuleBackward(v:count, mode())<CR>
vnoremap <silent>,R :<C-U>call fortify#MoveCursorRuleBackward(v:count, visualmode())<CR>
