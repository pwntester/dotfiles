" Written by Alvaro Munoz Sanchez
" Copyright (c) 2013 Alvaro Munoz Sanchez
"
" License MIT

" author: Alvaro Munoz

scriptencoding utf-8

" Initialization {{{1
if !has('python') || !has('nvim') || exists('g:loaded_fortify')
  finish
endif
let g:loaded_fortify = 1

" Completion {{{1
" Omnifunc function {{{2
function! fortify#complete(findstart, base)
if a:findstart
  let line = getline('.')
  let start = col('.') - 1
  while start > 0 && line[start - 1] =~ '[a-zA-Z0-9<>]'
    let start -= 1
  endwhile
  return start
else
  call fortify#complete_internal()
  return res
endif
endfun

" Status line {{{1
" Integration with statusline plugins. Returns ruletesting status message {{{2
function! fortify#StatusMsg()
  return g:fortify_message
endfunction

" Text Object and Motion backing functions {{{1
" Select FunctionIdentifier {{{2
function! fortify#SelectFunctionIdentifier(mode)
  call search('<FunctionIdentifier', 'bWe')
  echo a:mode
  if tolower(a:mode) == "a"
    normal! V
  else
    normal! jV
  endif
  call search('</FunctionIdentifier>', 'W')
  if tolower(a:mode) == "i"
    normal! k 
  endif
endfunction

" Select CDATA {{{2
function! fortify#SelectCDATA(mode)
  echo a:mode
  call search('<![CDATA[', 'bWe')
  if tolower(a:mode) == "a"
    normal! V
  else
    normal! jV
  endif
  call search(']]>', 'W')
  if tolower(a:mode) == "i"
    normal! k 
  endif
endfunction

" Select Rule {{{2
function! fortify#SelectRule(count, mode)
  echo a:mode
  let l:count = a:count
  if l:count == 0
    let l:count = 1
  endif
  let i = 0
  call search('<[a-zA-Z]\+Rule ', 'bWc')
  if tolower(a:mode) == "a"
    normal! V
  else
    normal! v 
  endif
  while i < l:count
    call search('</[a-zA-Z]\+Rule>', 'eW')
    let i += 1
  endwhile
endfunction

" Move cursor forward {{{2
function! fortify#MoveCursorRuleForward(count, mode)
  echo a:mode
  let l:count = a:count
  if l:count == 0
    let l:count = 1
  endif
  let i = 0
  while i < l:count
    if tolower(a:mode) == "v"
      normal! gv
    endif
    call search('</[a-zA-Z]\+Rule>', 'eW')
    if tolower(a:mode) != "v"
      normal! j^
    endif
    let i += 1
  endwhile
endfunction

" Move cursor backward {{{2
function! fortify#MoveCursorRuleBackward(count, mode)
  echo a:mode
  let l:count = a:count
  if l:count == 0
    let l:count = 1
  endif
  let i = 0
  while i < l:count
    if tolower(a:mode) == "v"
      normal! gv
    endif
    call search('<[a-zA-Z]\+Rule ', 'bW')
    if tolower(a:mode) == "v"
      normal k
      call search('</[a-zA-Z]\+Rule>', 'eW')
    endif
    let i += 1
  endwhile
endfunction

" Rule Testing {{{1
" Async Handlers {{{2
" Chained command handler {{{3
function! fortify#InvokeChainedCommandsHandler(job_id, data, event)

  " Flush the TestPane buffer
  if s:testpane_buffer_timer != 0
    call timer_stop(s:testpane_buffer_timer)
    call fortify#FlushTestPaneBuffer(0)
    let s:testpane_buffer_timer = 0
  endif

  if len(g:fortify_commandlist) > 0
    let l:cmd = g:fortify_commandlist[0]
    let g:fortify_commandlist = g:fortify_commandlist[1:]
    if l:cmd == ["run_tests"]
      " Run tests asynchronously
      execute("RunTests ".g:fortify_fprpath)
      let g:fortify_message = ""
      " Load FPR in AuditPane asynchronously
      execute("LoadFPR ".g:fortify_fprpath)
    elseif l:cmd == ["run_tests_and_generate_fvdl"]
      " Run tests asynchronously
      execute("RunTests ".g:fortify_fprpath. " 1")
      let g:fortify_message = ""
      " Load FPR in AuditPane asynchronously
      execute("LoadFPR ".g:fortify_fprpath)
    elseif join(l:cmd) =~ "dump-structural-tree"
      " Structural Dump
      call fortify#PrintToTestPane('Generating Structural Dump: '.join(l:cmd))
      let g:fortify_structural_dump = ['']
      call fortify#PrintToTestPane('Running: '.join(l:cmd))
      call jobstart(l:cmd, {
                  \ 'on_stdout': function('g:fortify#PrintToBufferHandler'),
                  \ 'on_stderr': function('g:fortify#PrintToBufferHandler'),
                  \ 'on_exit': function('g:fortify#ShowStructuralDump'),
                  \ 'output': '',
                  \ })
    else
      " Translate or Scan
      let s:testpane_buffer = []
      " Flush output buffer every 3 seconds
      let s:testpane_buffer_timer = timer_start(3000, function('fortify#FlushTestPaneBuffer'), {'repeat':-1})

      call fortify#PrintToTestPane('Running: '.join(l:cmd))
      call jobstart(l:cmd, {
                  \ 'on_stdout': function('g:fortify#PrintHandler'),
                  \ 'on_stderr': function('g:fortify#PrintHandler'),
                  \ 'on_exit': function('g:fortify#InvokeChainedCommandsHandler'),
                  \ })
    endif
  else
    call fortify#PrintToTestPane("\nDone!")
    let g:fortify_message = ""
    call fortify#JobStopHandler('','','')
    " Flush the output buffer
    if s:testpane_buffer_timer != 0
        call timer_stop(s:testpane_buffer_timer)
        call fortify#FlushTestPaneBuffer(0)
        let s:testpane_buffer_timer = 0
    endif
  endif
endfunction

" Prints to TestPane {{{3
function! fortify#PrintToTestPane(str, ...)
    " Emulate default argument values
    let l:str      = a:str
    let l:filename = a:0 > 0 ? a:1 : ""
    let l:line     = a:0 > 1 ? a:2 : -1
    let l:base     = a:0 > 2 ? a:3 : ""

    if empty(l:str)
        return
    endif

    " change to test pane window
    let l:testpanewinnr = bufwinnr('__TestPane__')
    if l:testpanewinnr > -1

        " remember current window
        let l:currentwinnr = winnr()

        " go to test pane
        call fortify#goto_win(l:testpanewinnr)

        " store line and file info and generate msg to print
        if !empty(l:filename) && l:line > -1
            let l:curline = line('.') + 1
            let l:test = {}
            let l:test.line = l:line
            let l:test.filename = l:base . "/" . l:filename
            let g:fortify#testinfo[l:curline] = l:test
            let l:str = l:filename . ':' . l:line . ' ' . l:str
        endif

        " print
        try
            for line in l:str
                if line != "" && line != "\n"
                    silent put =line
                endif
            endfor
        catch
            silent put =l:str
        endtry

        " scroll down to the bottom
        normal! zb

        " go back to previous win
        call fortify#goto_win(l:currentwinnr)

    endif

endfunction

" Flush Buffer to TestPane {{{3
function! fortify#FlushTestPaneBuffer(timer)
  call fortify#PrintToTestPane(s:testpane_buffer)
  let s:testpane_buffer = []
endfunction

" Prints to window {{{3
function! fortify#PrintHandler(job_id, data, event)
  if a:event == 'stdout' || a:event == 'stderr'
    for i in a:data
        let l:str = substitute(i, "\\[rulescript\\] ", "", "g")
        let l:str = substitute(l:str,"\n", "", "g")
        call add(s:testpane_buffer, l:str)
    endfor
  endif
endfunction

" Prints to Buffer {{{3
function! fortify#PrintToBufferHandler(job_id, data, event)
  let g:fortify_structural_dump = g:fortify_structural_dump[:-2] + [g:fortify_structural_dump[-1] . get(a:data, 0, '')] + a:data[1:]
endfunction

" Clean stuff after async execution {{{3
function! fortify#JobStopHandler(job_id, data, event)
endfunction

" Show Structural dump {{{2
function! fortify#ShowStructuralDump(job_id, data, event)
  let g:fortify_message = ""
  call fortify#JobStopHandler('','','')
  enew
  "setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
  call append(line('$'), g:fortify_structural_dump)
  setlocal foldmethod=indent
  let g:fortify_structural_dump = ['']
endfunction

" Audit & Test Panels {{{1
" Basic init {{{2
let s:short_help      = 1
let s:is_maximized    = 0
let s:icon_closed = g:fortify_auditpane_iconchars[0]
let s:icon_open   = g:fortify_auditpane_iconchars[1]
let s:icon_closed2 = g:fortify_auditpane_iconchars[2]
let s:icon_open2   = g:fortify_auditpane_iconchars[3]
let g:fortify#scaninfo = {}
let g:fortify#testinfo = {}
let g:fortify#scaninfo_orig = {}

" fortify#MapAuditPaneKeys() {{{2
function! fortify#MapAuditPaneKeys() abort
    let maps = [
        \ ['jump',          'fortify#JumpToTag(0)'],
        \ ['preview',       'fortify#JumpToTag(1)'],
        \ ['info',          'fortify#ShowIssueDetails()'],
        \ ['filter',        'fortify#FilterIssues()'],
        \ ['nexttrace',     'fortify#ChangeTrace(1)'],
        \ ['previoustrace', 'fortify#ChangeTrace(-1)'],
        \ ['copyruleid',    'fortify#CopyRuleID()'],
        \ ['togglefold',    'fortify#ToggleFold()'],
        \ ['openallfolds',  'fortify#SetFoldLevel(0)'],
        \ ['closeallfolds', 'fortify#SetFoldLevel(1)'],
        \ ['close',         'fortify#CloseAuditPaneWindow()'],
        \ ['zoomwin',       'fortify#ZoomAuditPaneWindow()'],
        \ ['help',          'fortify#ToggleHelp()'],
    \ ]

    for [map, func] in maps
        let def = get(g:, 'fortify_auditpane_map_' . map)
        if type(def) == type("")
            let keys = [def]
        else
            let keys = def
        endif
        for key in keys
            execute 'nnoremap <script> <silent> <buffer> ' . key . ' :call ' . func . '<CR>'
        endfor
        unlet def
    endfor

endfunction

" fortify#MapTestPaneKeys() {{{2
function! fortify#MapTestPaneKeys() abort
    let maps = [
        \ ['jump',          'fortify#JumpToCode(0)'],
        \ ['preview',       'fortify#JumpToCode(1)'],
    \ ]

    for [map, func] in maps
        let def = get(g:, 'fortify_testpane_map_' . map)
        if type(def) == type("")
            let keys = [def]
        else
            let keys = def
        endif
        for key in keys
            execute 'nnoremap <script> <silent> <buffer> ' . key . ' :call ' . func . '<CR>'
        endfor
        unlet def
    endfor

endfunction
" fortify#goto_win() {{{2
function! fortify#goto_win(winnr, ...) abort
    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w' : 'wincmd ' . a:winnr
    let noauto = a:0 > 0 ? a:1 : 0

    if noauto
        noautocmd execute cmd
    else
        execute cmd
    endif
endfunction

" fortify#mark_window() {{{2
" Mark window with a window-local variable so we can jump back to it even if
" the window numbers have changed.
function! fortify#mark_window() abort
    let w:fortify_auditpane_mark = 1
endfunction

" fortify#goto_markedwin() {{{2
" Go to a previously marked window and delete the mark.
function! fortify#goto_markedwin(...) abort
    let noauto = a:0 > 0 ? a:1 : 0
    for window in range(1, winnr('$'))
        call fortify#goto_win(window, noauto)
        if exists('w:fortify_auditpane_mark')
            unlet w:fortify_auditpane_mark
            break
        endif
    endfor
endfunction

" fortify#RenderContent() {{{2
function! fortify#RenderContent() abort

    let auditpanewinnr = bufwinnr('__AuditPane__')
    let prevwinnr = winnr()

    call fortify#goto_win(auditpanewinnr, 1)

    setlocal modifiable

    silent %delete _
    call fortify#PrintHelp()

    if !empty(g:fortify#scaninfo) && has_key(g:fortify#scaninfo, 'nissues')
        call fortify#PrintIssues()
    else
        silent  put ='\" No issues found.'
    endif

    " Delete empty lines at the end of the buffer
    for linenr in range(line('$'), 1, -1)
        if getline(linenr) =~ '^$'
            execute 'silent ' . linenr . 'delete _'
        else
            break
        endif
    endfor

    normal! gg

    setlocal nomodifiable

    call fortify#goto_win(prevwinnr, 1)

endfunction

" fortify#PrintIssues() {{{2
function! fortify#PrintIssues() abort

    silent put ='Build ID: ' . g:fortify#scaninfo.build_id
    silent put ='Issues:   ' . g:fortify#scaninfo.nissues
    silent put _

    for category in g:fortify#scaninfo.categories

        if empty(category.issues)
            continue
        endif

        if category.is_folded
            let foldmarker = s:icon_closed
        else
            let foldmarker = s:icon_open
        endif

        " Print Category name
        " TODO: category.count is the real count of issues,
        " len(category.issues) is the number of issues/groups
        " Im using the later since its automatically recalculated when
        " filtering. But it would be better to show the real number of issues
        silent put =foldmarker . ' ' . category.name . ' [' . len(category.issues) . ']'

        " Save the current issue in scaninfo.sline map
        let curline = line('.')
        let category.sline = curline
        let g:fortify#scaninfo.sline[curline] = category

        if !category.is_folded
            let issues = category.issues

            " Process issues
            for issue in issues

                if has_key(issue, 'count')
                    " Print group
                    let group = issue

                    if group.is_folded
                        let foldmarker = s:icon_closed
                    else
                        let foldmarker = s:icon_open
                    endif

                    let str = group.filename . ':' . group.line . ' ' . '[' . group.count . ']'
                    silent put =repeat(' ', g:fortify_auditpane_indent * 2) . foldmarker . ' ' . str

                    " Save the current issue in scaninfo.sline map
                    let curline = line('.')
                    let issue.sline = curline
                    let g:fortify#scaninfo.sline[curline] = group

                    if !group.is_folded
                        for issue in group.issues
                            call fortify#PrintIssue(issue, 4)
                        endfor
                    endif
                else
                    " Print issue
                    call fortify#PrintIssue(issue, 2)
                endif
            endfor
        endif
    endfor
endfunction

" fortify#PrintIssue() {{{2
function! fortify#PrintIssue(issue, indent_level) abort
    let issue = a:issue
    let indent_level = a:indent_level

    if issue.is_folded
        let foldmarker = s:icon_closed2
    else
        let foldmarker = s:icon_open2
    endif

    if has_key(issue, 'friority')
        if issue.friority == 'low'
            let friority = '@'. foldmarker .'@'
        elseif issue.friority == 'medium'
            let friority = '='. foldmarker .'='
        elseif issue.friority == 'high'
            let friority = '%'. foldmarker .'%'
        elseif issue.friority == 'critical'
            let friority = '#'. foldmarker .'#'
        elseif issue.friority == ''
            let friority = foldmarker
        endif
    else
        let friority = foldmarker
    endif


    if has_key(issue, 'belongs_to_group')
        " Get filename and line from source node
        let filename = get(get(issue.traces, 0), 0).filename
        let line = get(get(issue.traces, 0), 0).line
    else
        " Get filename and line from sink(issue) node
        let filename = issue.filename
        let line = issue.line
    endif
    let str = filename . ':' . line
    silent put =repeat(' ', g:fortify_auditpane_indent * indent_level) . friority . ' ' . str

    " Save the current issue in scaninfo.sline map
    let curline = line('.')
    let issue.sline = curline
    let g:fortify#scaninfo.sline[curline] = issue

    " Print External Entries if any
    if !issue.is_folded && !empty(issue.external_entries)
        for external_entry in issue.external_entries
            silent put ='  ' . repeat(' ', g:fortify_auditpane_indent * indent_level + g:fortify_auditpane_indent) . '> ' . external_entry.label . ': ' . external_entry.url
        endfor
        silent put ='  ' . repeat(' ', g:fortify_auditpane_indent * indent_level + g:fortify_auditpane_indent) . '-----------------------------------------'

        " TODO: This bits can be refactored into a function
        " Save the current issue in scaninfo.sline map
        let curline = line('.')
        let issue.sline = curline
        let g:fortify#scaninfo.sline[curline] = external_entry
    endif

    if !issue.is_folded && !empty(issue.traces)
        let active_trace = issue.active_trace

        if len(issue.traces) > 1
            let str = (active_trace + 1) . '/' . len(issue.traces)
            silent put ='  ' . repeat(' ', g:fortify_auditpane_indent * indent_level + g:fortify_auditpane_indent) . 'Trace: ' . str
        endif

        let trace = get(issue.traces, active_trace)
        let index = 0
        for trace_node in trace
            call fortify#PrintNode(trace_node, indent_level, issue.analyzer)
            " Print Facts for last node
            if has_key(trace_node, 'facts') && index == len(trace) - 1
                for fact in trace_node['facts']
                    silent put ='  ' . repeat(' ', g:fortify_auditpane_indent * indent_level) . '[' . fact . ']'
                endfor
            endif
            let index = index + 1
        endfor
    endif
endfunction

" fortify#PrintNode() {{{2
function! fortify#PrintNode(node, indent_level, analyzer) abort
    let node = a:node

    " Fold merker
    let foldmarker = ' '
    if has_key(node, 'children')
        if len(node.children) > 0
            if node.is_folded
                let foldmarker = s:icon_closed
            else
                let foldmarker = s:icon_open
            endif
        endif
    endif

    " Rule marker
    let rulemarker = ""
    if has_key(node, 'ruleid')
        let rulemarker = " *"
    endif

    " Action marker
    let actionmarker = ""
    if a:analyzer == 'dataflow' || a:analyzer == 'controlflow'
        let actionmarker = "  "
        if has_key(node, 'type')
            if node.type == "Return"
                let actionmarker = "↵ "
            elseif node.type == "Assign"
                let actionmarker = "≔ "
            elseif node.type == "InCall"
                let actionmarker = "→ "
            elseif node.type == "OutCall"
                let actionmarker = "⟵ "
            elseif node.type == "InOutCall"
                let actionmarker = "↔ "
            elseif node.type == "AssignGlobal"
                let actionmarker = "ⓖ "
            elseif node.type == "ReadGlobal"
                let actionmarker = "⤝ "
            elseif node.type == "BranchTaken"
                let actionmarker = "ᛦ "
            elseif node.type == "BranchNotTaken"
                let actionmarker = "ᚼ "
            elseif node.type == "Jump"
                let actionmarker = "⤸ "
            elseif node.type == ""
                let actionmarker = "⦿ "
            endif
        endif
    endif

    " Node string
    let str = foldmarker . actionmarker . node.filename . ':' . node.line . ' - ' . node.label . rulemarker
    silent put =repeat(' ', g:fortify_auditpane_indent * a:indent_level) . str

    " Save the current issue in scaninfo.sline map
    let curline = line('.')
    let a:sline = curline
    let g:fortify#scaninfo.sline[curline] = a:node

    if !node.is_folded && len(node.children) > 0
        for child in node.children
            call fortify#PrintNode(child, a:indent_level+2, a:analyzer)
        endfor
    endif
endfunction

" fortify#PrintHelp() {{{2
function! fortify#PrintHelp() abort
    if s:short_help
        silent 0put ='\" Press ' . s:get_map_str('help') . ' for help'
        silent  put _
    elseif !s:short_help
        silent 0put ='\" auditpane keybindings'
        silent  put ='\"'
        silent  put ='\" --------- General ---------'
        silent  put ='\" ' . s:get_map_str('jump') . ': Jump to tag definition'
        silent  put ='\" ' . s:get_map_str('preview') . ': As above, but stay in AuditPane'
        silent  put ='\" ' . s:get_map_str('info') . ': Show Issue details'
        silent  put ='\" ' . s:get_map_str('filter') . ': Filter Issues'
        silent  put ='\" ' . s:get_map_str('copyruleid') . ': Yank Rule Id'
        silent  put ='\" ' . s:get_map_str('nexttrace') . ': Change Trace'
        silent  put ='\" ' . s:get_map_str('previoustrace') . ': Previous Trace'
        silent  put ='\"'
        silent  put ='\" ---------- Folds ----------'
        silent  put ='\" ' . s:get_map_str('togglefold') . ': Toggle fold'
        silent  put ='\" ' . s:get_map_str('openallfolds') . ': Open all folds'
        silent  put ='\" ' . s:get_map_str('closeallfolds') . ': Close all folds'
        silent  put ='\"'
        silent  put ='\" ---------- Misc -----------'
        silent  put ='\" ' . s:get_map_str('zoomwin') . ': Zoom window in/out'
        silent  put ='\" ' . s:get_map_str('close') . ': Close window'
        silent  put ='\" ' . s:get_map_str('help') . ': Toggle help'
        silent  put _
    endif
endfunction
function! s:get_map_str(map) abort
    let def = get(g:, 'fortify_auditpane_map_' . a:map)
    if type(def) == type("")
        return def
    else
        return join(def, ', ')
    endif
endfunction

" fortify#RenderKeepView() {{{2
function! fortify#RenderKeepView(...) abort
    if a:0 == 1
        let line = a:1
    else
        let line = line('.')
    endif

    let curcol  = col('.')
    let topline = line('w0')

    call fortify#RenderContent()

    let scrolloff_save = &scrolloff
    set scrolloff=0

    call cursor(topline, 1)
    normal! zt
    call cursor(line, curcol)

    let &scrolloff = scrolloff_save

    redraw
endfunction

" fortify#JumpToTag() {{{2
function! fortify#JumpToTag(stay_in_pane) abort
    let info = get(g:fortify#scaninfo.sline, line('.'))

    if empty(info) || !has_key(info, 'path')
        return
    endif

    " save audit pane window
    let l:auditpanewinnr = winnr()

    " locate main window
    let l:mainwinnr = fortify#mainWindow()

    if l:mainwinnr > -1
        " go to wider window
        call fortify#goto_win(l:mainwinnr)

        execute 'e ' . fnameescape(info.path)

        " Mark current position so it can be jumped back to
        mark '

        " Jump to the line where the tag is defined. Don't use the search pattern
        " since it doesn't take the scope into account and thus can fail if tags
        " with the same name are defined in different scopes (e.g. classes)
        execute info.line

        " Center the tag in the window
        normal! z.
        normal! zv

        if a:stay_in_pane
            call fortify#goto_win(l:auditpanewinnr)
            redraw
        endif
    endif

endfunction

" fortify#JumpToCode() {{{2
function! fortify#JumpToCode(stay_in_pane) abort
    let info = get(g:fortify#testinfo, line('.'))

    if empty(info) 
        echo "No info for current line: " . line('.')
        return
    endif

    if !has_key(info, 'filename')
        echo "No filename"
        return
    endif

    " save test window
    let l:testpanewinnr = winnr()

    " locate main window
    let l:mainwinnr = fortify#mainWindow()

    if l:mainwinnr > -1
        " go to main window
        call fortify#goto_win(l:mainwinnr)

        echo info.filename

        execute 'e ' . fnameescape(info.filename)

        " Mark current position so it can be jumped back to
        mark '

        " Jump to the line where the tag is defined. Don't use the search pattern
        " since it doesn't take the scope into account and thus can fail if tags
        " with the same name are defined in different scopes (e.g. classes)
        execute info.line

        " Center the tag in the window
        normal! z.
        normal! zv

        if a:stay_in_pane
            call fortify#goto_win(l:testpanewinnr)
            redraw
        endif
    endif
endfunction

" fortify#CopyRuleID() {{{2
function! fortify#CopyRuleID() abort
    let info = get(g:fortify#scaninfo.sline, line('.'))

    if empty(info) || !has_key(info, 'ruleid')
        return
    endif

    let ruleid = info.ruleid

    call setreg('0', ruleid)

    redraw | echo "Copied ruleid " . ruleid . " to register 0"
endfunction

" fortify#ShowIssueDetails() {{{2
function! fortify#ShowIssueDetails() abort
    let info = get(g:fortify#scaninfo.sline, line('.'))

    if empty(info) || !has_key(info, 'analyzer') || !has_key(info, 'iid')
        return
    endif

    let analyzer = info.analyzer
    let iid = info.iid

    redraw | echo "Analyzer: " . analyzer . " InstanceID: " . iid

endfunction

" fortify#FilterIssues() {{{2
function! fortify#FilterIssues() abort

    call inputsave()
    let l:filter = input("Filter: ")
    call inputrestore()

    if (l:filter == "" || empty(l:filter))
        let g:fortify#scaninfo = deepcopy(g:fortify#scaninfo_orig)
    else
        let g:fortify#scaninfo = deepcopy(g:fortify#scaninfo_orig)

        " filter scaninfo
        let l:filter = substitute(l:filter, "analyzer", "v:val.analyzer", "")
        let l:filter = substitute(l:filter, "iid", "v:val.iid", "")
        let l:filter = substitute(l:filter, "ruleid", "v:val.ruleid", "")
        let l:filter = substitute(l:filter, "issue.", "v:val.", "")
        for category in g:fortify#scaninfo.categories
            let category.issues = filter(copy(category.issues), l:filter)
        endfor
    endif

    call fortify#RenderContent()

endfunction
" fortify#ToggleHelp() {{{2
function! fortify#ToggleHelp() abort
    let s:short_help = !s:short_help

    " Prevent highlighting from being off after adding/removing the help text
    match none

    call fortify#RenderContent()

    execute 1
    redraw
endfunction

" fortify#ToggleFold() {{{2
function! fortify#ToggleFold() abort
    if empty(g:fortify#scaninfo)
        echo g:fortify#scaninfo.nissues
        return
    endif

    match none

    let node = get(g:fortify#scaninfo.sline, line('.'))

    if empty(node) || !has_key(node, 'is_folded')
        return
    endif

    if node.is_folded == 0
        let node.is_folded = 1
    elseif node.is_folded == 1
        let node.is_folded = 0
    else
        let node.is_folded = 0
    endif

    let newline = line('.')

    call fortify#RenderKeepView(newline)

endfunction

" fortify#SetFoldLevel() {{{2
function! fortify#SetFoldLevel(level) abort
    if a:level < 0
        return
    endif

    let scaninfo = g:fortify#scaninfo
    if empty(scaninfo)
        return
    endif

    for category in scaninfo.categories
        let category.is_folded = a:level
        for issue in category.issues
            let issue.is_folded = a:level
            if has_key(issue, 'traces')
                for trace in issue.traces
                    for node in trace
                        call s:SetNodeFoldLevel(node, a:level)
                    endfor
                endfor
            endif
        endfor
    endfor

    call fortify#RenderContent()
endfunction

function! s:SetNodeFoldLevel(node, level) abort
    let a:node.is_folded = a:level
    if has_key(a:node, 'children')
        for child in a:node.children
            call s:SetNodeFoldLevel(child, a:level)
        endfor
    endif
endfunction

" fortify#ChangeTrace(direction) {{{2
function! fortify#ChangeTrace(offset) abort

    let line = line('.') - 1
    let issue = get(g:fortify#scaninfo.sline, line)

    if has_key(issue, 'active_trace')
        if (issue.active_trace == 0 && a:offset == -1) || (issue.active_trace == len(issue.traces) - 1 && a:offset == 1)
            return
        endif
        let issue.active_trace += a:offset
        call fortify#RenderKeepView(line + 1)
    endif

endfunction

" fortify#ZoomAuditPaneWindow() {{{2
function! fortify#ZoomAuditPaneWindow() abort
    if s:is_maximized
        execute 'vertical resize ' . g:fortify_auditpane_width
        execute s:winrestcmd
        let s:is_maximized = 0
    else
        let s:winrestcmd = winrestcmd()
        if g:fortify_auditpane_zoomwidth == 1
            vertical resize
        elseif g:fortify_auditpane_zoomwidth == 0
            let func = exists('*strdisplaywidth') ? 'strdisplaywidth' : 'strlen'
            let maxline = max(map(getline(line('w0'), line('w$')),
                                \ func . '(v:val)'))
            execute 'vertical resize ' . maxline
        elseif g:fortify_auditpane_zoomwidth > 1
            execute 'vertical resize ' . g:fortify_auditpane_zoomwidth
        endif
        let s:is_maximized = 1
    endif
endfunction

" fortify#OpenAuditPaneWindow() {{{2
function! fortify#OpenAuditPaneWindow() abort

    " mark current window to go back later
    call fortify#mark_window()

    " check if audit pane is already present
    let l:auditpanewinnr = bufwinnr('__AuditPane__')
    if l:auditpanewinnr != -1
        if winnr() != l:auditpanewinnr
            call fortify#goto_win(l:auditpanewinnr)
        endif
        
        " go back to marked win
        call fortify#goto_markedwin()

        return
    endif

    " prepare split arguments
    if g:fortify_auditpane_pos == 'right'
        let pos = 'botright'
    elseif g:fortify_auditpane_pos == 'left'
        let pos = 'topleft'
    else
        echo("Incorrect g:fortify_auditpane_pos value")
        return
    end

    " locate main window
    let l:mainwinnr = fortify#mainWindow()

    if l:mainwinnr > -1
        " go to wider windows 
        call fortify#goto_win(l:mainwinnr)
    endif

    " split
    exe 'silent keepalt ' . pos . ' vertical ' . g:fortify_auditpane_width . 'split __AuditPane__'
    
    " init the audit pane
    call fortify#InitAuditPaneWindow()

endfunction

" fortify#InitAuditPaneWindow() {{{2
function! fortify#InitAuditPaneWindow() abort
    setlocal filetype=fortifyauditpane
    setlocal noreadonly
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal foldmethod&
    setlocal foldexpr&

    call fortify#MapAuditPaneKeys()

    " go back to marked win
    call fortify#goto_markedwin()

endfunction

" fortify#CloseAuditPaneWindow() {{{2
function! fortify#CloseAuditPaneWindow() abort
    let auditpanewinnr = bufwinnr('__AuditPane__')
    if auditpanewinnr == -1
        return
    endif

    if winnr() == auditpanewinnr
        if winbufnr(2) != -1
            " Other windows are open, only close the auditpane one
            close

            " Try to jump to the correct window after closing
            call fortify#goto_win('p')

        endif
    else
        " Go to the auditpane window, close it and then come back to the original
        " window. Save a win-local variable in the original window so we can
        " jump back to it even if the window number changed.
        call fortify#mark_window()
        call fortify#goto_win(auditpanewinnr)
        close

        call fortify#goto_markedwin()
    endif

    " The window sizes may have changed due to the shrinking happening after
    " the window closing, so equalize them again.
    if &equalalways
        wincmd =
    endif

endfunction

" Locate main (largest) window
function! fortify#mainWindow() abort

    let l:windowids = []
    let l:widerwin = 0
    let l:widerwidth = 0

    " get all windows ids
    windo call add(l:windowids, winnr())

    " find wider window
    for w in l:windowids
        if winwidth(w) > l:widerwidth
            let l:widerwin = w
            let l:widerwidth = winwidth(w)
        endif
    endfor

    return l:widerwin

endfunction


" fortify#ClearTestPaneWindow() {{{2
function! fortify#ClearTestPaneWindow() abort
    " mark current window to go back later
    call fortify#mark_window()

    " check if test pane is already present
    let l:testpanewinnr = bufwinnr('__TestPane__')
    if l:testpanewinnr != -1
        if winnr() != l:testpanewinnr
            call fortify#goto_win(l:testpanewinnr)
        endif
        
        normal! ggdG
        
        " go back to marked win
        call fortify#goto_markedwin()

        return
    endif
endfunction

" fortify#OpenTestPaneWindow() {{{2
function! fortify#OpenTestPaneWindow() abort

    let s:testpane_buffer = []
    let s:testpane_buffer_timer = 0

    " mark current window to go back later
    call fortify#mark_window()

    " check if test pane is already present
    let l:testpanewinnr = bufwinnr('__TestPane__')
    if l:testpanewinnr != -1
        if winnr() != l:testpanewinnr
            call fortify#goto_win(l:testpanewinnr)
        endif
        
        "normal! ggdG
        
        " go back to marked win
        call fortify#goto_markedwin()

        return
    endif

    " locate main window
    let l:mainwinnr = fortify#mainWindow()

    if l:mainwinnr > -1
        " go to wider windows 
        call fortify#goto_win(l:mainwinnr)
    endif

    " split
    execute 'silent keepalt rightbelow 15 split __TestPane__'
    
    " init the audit pane
    call fortify#InitTestPaneWindow()

endfunction
" fortify#InitTestPaneWindow() {{{2
function! fortify#InitTestPaneWindow() abort
    setlocal filetype=fortifytestpane
    setlocal noreadonly
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nolist
    setlocal nowrap
    setlocal textwidth=0
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal foldmethod&
    setlocal foldexpr&

    call fortify#MapTestPaneKeys()

    " go back to marked win
    call fortify#goto_markedwin()

endfunction

