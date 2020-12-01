local mappings = {

  -- * for visual selected text
  ['v*'] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] };

  -- repeat last search updating search index
  ['nn'] = { '/<CR>' };
  ['nN'] = { '?<CR>' };

  -- escape to normal mode
  ['ijk'] = { '<ESC>' };
  ['vjk'] = { '<ESC>' };
  ['tjk'] = { [[<C-\><C-n>]] };

  -- shifting visual block should keep it selected
  ['v<'] = { '<gv' };
  ['v>'] = { '>gv|' };

  -- automatically jump to end of text you pasted
  ['vy'] = { 'y`' };
  ['vp'] = { 'p`' };
  ['np'] = { 'p`' };

  -- go up/down on visual line
  ['vj'] = { 'gj', noremap = false; };
  ['vk'] = { 'gk', noremap = false; };
  ['nj'] = { [[ (v:count? 'j' : 'gj') ]], expr = true; };
  ['nk'] = { [[ (v:count? 'k' : 'gk') ]], expr = true; };

  -- go to begining or end of line
  ['nB'] = { '^' };
  ['nE'] = { '$' };

  -- move between windows
  ['n<c-k>'] = { ':TmuxNavigateUp<CR>' };
  ['n<c-j>'] = { ':TmuxNavigateDown<CR>' };
  ['n<c-h>'] = { ':TmuxNavigateLeft<CR>' };
  ['n<c-l>'] = { ':TmuxNavigateRight<CR>' };

  -- ['n<c-k>'] = { ':wincmd k<CR>' };
  -- ['n<c-j>'] = { ':wincmd j<CR>' };
  -- ['n<c-h>'] = { ':wincmd h<CR>' };
  -- ['n<c-l>'] = { ':wincmd l<CR>' };

  -- disable keys
  ['n<up>'] = { '<nop>' };
  ['n<down>'] = { '<nop>' };
  ['n<left>'] = { '<nop>' };
  ['n<right>'] = { '<nop>' };
  ['i<up>'] = { '<nop>' };
  ['i<down>'] = { '<nop>' };
  ['i<left>'] = { '<nop>' };
  ['i<right>'] = { '<nop>' };
  ['n<space>'] = { '<nop>' };
  ['n<esc>'] = { '<nop>' };

  -- resize splits
  ['n>'] = { ':execute "vertical resize +5"<CR>' };
  ['n<'] = { ':execute "vertical resize -5"<CR>' };
  ['n+'] = { ':execute "resize +5"<CR>' };
  ['n-'] = { ':execute "resize -5"<CR>' };

  -- swap lines
  ['n[e'] = { [[:<c-u>execute 'move -1-'. v:count1<cr>]] };
  ['n]e'] = { [[:<c-u>execute 'move +'. v:count1<cr>]] };

  -- paste keeping the default register
  ['v<leader>p'] = { '"_dP' };

  -- copy & paste to system clipboard
  ['v<leader>y'] = { '"*y', noremap = false; };

  -- quickly select text you pasted
  ['ngp'] = { [['`[' . strpart(getregtype(), 0, 1) . '`]']], expr = true; };

  -- jump to next/previous search match on search mode
  ['c<C-j>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-g>' : '<C-j>']], expr = true; };
  ['c<C-k>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-t>' : '<C-k>']], expr = true; };

  -- these work like * and g*, but do not move the cursor and always set hls.
  ['_*'] = { [[:let @/ = '\<'.expand('<cword>').'\>'<bar>set hlsearch<C-M>]] };
  ['_g*'] = { [[:let @/ = expand('<cword>')<bar>set hlsearch<C-M>]] };

  -- TELESCOPE
  ['n<leader>m'] = { [[<cmd>lua require'plugins.telescope'.mru()<CR>]] };
  ['n<leader>f'] = { [[<cmd>lua require'plugins.telescope'.fd()<CR>]] };
  ['n<leader>r'] = { [[<cmd>lua require'plugins.telescope'.reloader()<CR>]] };
  ['n<leader>o'] = { [[<cmd>lua require'plugins.telescope'.buffers()<CR>]] };
  ['n<leader>s'] = { [[<cmd>lua require'plugins.telescope'.treesitter()<CR>]] };
  ['n<leader>l'] = { [[<cmd>lua require'plugins.telescope'.live_grep()<CR>]] };

  -- VIM-SMOOTHIE
  ['n<c-d>'] = { '<Plug>(SmoothieDownwards)', noremap = false; };
  ['n<c-e>'] = { '<Plug>(SmoothieUpwards)', noremap = false; };

  -- GOYO
  ['n<leader>y'] = { ':Goyo<CR>' };

  -- LAZY-GIT
  ['n<Leader>g'] = { [[:call luaeval('require("window").floating_window({border=false;width_per=0.9;height_per=0.9;})')<bar>call termopen('lazygit')<CR>]] };

  -- VEM-TABLINE
  -- ['n<s-h>'] = { '<Plug>vem_prev_buffer-', noremap = false; };
  -- ['n<s-l>'] = { '<Plug>vem_next_buffer-', noremap = false; };
  -- ['n<leader>['] = { '<Plug>vem_move_buffer_left-', noremap = false; };
  -- ['n<leader>]'] = { '<Plug>vem_move_buffer_right-', noremap = false; };

  -- DIRVISH
  ['ngE'] = { [[:call ToggleDirvish('')<CR>]] };
  ['nge'] = { [[:call ToggleDirvish('%')<CR>]] };

  -- GIT-MESSANGER
  ['n<leader>gm'] = { [[<Plug>(git-messenger)]], noremap = false };

  -- WILDMENU
  ['c<c-j>'] = { '<right>' };
  ['c<c-k>'] = { '<left>' };
  ['c<c-h>'] = { '<space><bs><left>' };
  ['c<c-l>'] = { '<space><bs><right>' };

  -- Treesitter
  -- ['ngnn'] = { [[<Plug>(TsSelInit)]]     , noremap = false};
  -- ['xgrn'] = { [[<Plug>(TsSelNodeIncr)]] , noremap = false};
  -- ['xgrm'] = { [[<Plug>(TsSelNodeDecr)]] , noremap = false};
  -- ['xgrc'] = { [[<Plug>(TsSelScopeIncr)]], noremap = false};
  -- ['xgrd'] = { [[<Plug>(TsSelScopeDecr)]], noremap = false};
  -- ['ngrr'] = { [[<Plug>(TsRename)]]      , noremap = false};
  -- ['ngtd'] = { [[<Plug>(TsGotoDef)]]     , noremap = false};
  -- ['ngnu'] = { [[<Plug>(TsGotoNextUse)]] , noremap = false};
  -- ['ngpu'] = { [[<Plug>(TsGotoPrevUse)]] , noremap = false};
  -- ['ngnD'] = { [[<Plug>(TsListDefs)]]    , noremap = false};
  ['n]fs'] = { [[<Plug>(TsGotoNextFuncStart]],   noremap = false};
  ['n]cs'] = { [[<Plug>(TsGotoNextClassStart)]], noremap = false};
  ['n]fe'] = { [[<Plug>(TsGotoNextFuncEnd)]],    noremap = false};
  ['n]ce'] = { [[<Plug>(TsGotoNextClassEnd)]],   noremap = false};
  ['n[fs'] = { [[<Plug>(TsGotoPrevFuncStart)]],  noremap = false};
  ['n[cs'] = { [[<Plug>(TsGotoPrevClassStart)]], noremap = false};
  ['n[fe'] = { [[<Plug>(TsGotoPrevFuncEnd)]],    noremap = false};
  ['n[ce'] = { [[<Plug>(TsGotoPrevClassEnd)]],   noremap = false};

-- nmap <leader>jd <plug>(ls-definition)
-- nmap <leader>jh <plug>(ls-hover)
-- nmap <leader>jr <plug>(ls-references)
-- nmap <leader>js <plug>(ls-signature-help)
-- nmap <leader>jf <plug>(ls-formatting)

  -- LSP
  ['ngl']     = { [[<Plug>(LspShowDiagnostics)]]  , noremap = false};
  ['ngd']     = { [[<Plug>(LspGotoDef)]]          , noremap = false};
  ['ngpd']    = { [[<Plug>(LspPeekDef)]]          , noremap = false};
  ['ngi']     = { [[<Plug>(LspGotoImpl)]]         , noremap = false};
  ['ngD']     = { [[<Plug>(LspGotoDecl)]]         , noremap = false};
  ['ngr']     = { [[<Plug>(LspShowReferences)]]   , noremap = false};
  ['ng=']     = { [[<Plug>(LspFormat)']]          , noremap = false};
  ['ngK']     = { [[<Plug>(LspHover)]]            , noremap = false};
  ['ngca']    = { [[<Plug>(LspCodeActions)]]      , noremap = false};
  ['ngcr']    = { [[<Plug>(LspRename)]]           , noremap = false};
  ['i<c-s>']  = { [[<Plug>(LspShowSignatureHelp)]], noremap = false};

  ['n<leader>dn']  = { [[<Plug>(LspNextDiagnostic)]], noremap = false};
  ['n<leader>dp']  = { [[<Plug>(LspPrevDiagnostic)]], noremap = false};

  -- ['ngtt'] = { [[<Plug>(LspGotoTypeDef)]]      , noremap = false};
  -- ['ngds'] = { [[<Plug><LspDocumentSymbol)]]   , noremap = false};
  -- ['ngws'] = { [[<Plug><LspWorkspaceSymbol)]]  , noremap = false};
  -- ['ngic'] = { [[<Plug>(LspIncomingCalls)]]    , noremap = false};
  -- ['ngoc'] = { [[<Plug>(LspOutgoingCalls)]]    , noremap = false};

  -- JDTLS
  -- ['ngR']  = { [[<Plug>(LspRefactor)]],            noremap = false};
  -- ['ngoi'] = { [[<Plug>(LspOrganizeImports)]],     noremap = false};
  -- ['ngev'] = { [[<Plug>(LspExtractVar)]],          noremap = false};
  -- ['ngem'] = { [[<Plug>(LspExtractMethod)]],       noremap = false};
  -- ['vgev'] = { [[<Plug>(VisualLspExtractVar)]],    noremap = false};
  -- ['vgem'] = { [[<Plug>(VisualLspExtractMethod)]], noremap = false};

  -- COMPLETION.NVIM + SNIPPETS.NVIM
  ['i<CR>']  = { [[pumvisible() ? "\<c-y>\<cr>" : "\<CR>"]], expr = true; };
  ['i<c-j>'] = { [[pumvisible() ? "\<C-n>" : "\<cmd>lua return require'snippets'.expand_or_advance()<CR>"]], expr = true; };
  ['i<c-k>'] = { [[pumvisible() ? "\<C-p>" : "\<cmd>lua return require'snippets'.advance_snippet(-1)<CR>" ]], expr = true; };
  ['i<Tab>'] = { [[complete_info()["selected"] != "-1" ?]]..
                 [["\<Plug>(completion_confirm_completion)" : v:lua.check_back_space() ?]]..
                 [["\<Tab>" : completion#trigger_completion()]], expr = true; }
}

vim.cmd [[ let mapleader = "\<Space>" ]]
require'functions'.map(mappings, { silent = true; noremap = true; })

