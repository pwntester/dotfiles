local mappings = {
  ["all"] = {
    -- terminal
    ["t<Esc>"] = { [[<C-\><C-n>]] },

    -- * for visual selected text
    ["v*"] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] },

    -- escape to normal mode
    ["ijk"] = { "<ESC>" },
    ["tjk"] = { [[<C-\><C-n>]] },

    -- shifting visual block should keep it selected
    ["v<"] = { "<gv" },
    ["v>"] = { ">gv|" },

    -- automatically jump to end of text you pasted
    ["vy"] = { "y`]" },
    ["vp"] = { "p`]" },
    ["np"] = { "p`]" },

    -- go up/down on visual line
    ["vj"] = { "gj", noremap = false },
    ["vk"] = { "gk", noremap = false },
    ["nj"] = { [[ (v:count? 'j' : 'gj') ]], expr = true },
    ["nk"] = { [[ (v:count? 'k' : 'gk') ]], expr = true },

    -- go to begining or end of line
    ["nB"] = { "^" },
    ["nE"] = { "$" },
    ["c<C-a>"] = { "<home>" },
    ["c<C-e>"] = { "<end>" },

    -- move between windows
    ["n<C-p>"] = { "<Plug>(choosewin)", noremap = false },

    -- ['n<C-h>'] = {"<CMD>lua require('Navigator').left()<CR>" };
    -- ['n<C-k>'] = {"<CMD>lua require('Navigator').up()<CR>" };
    -- ['n<C-l>'] = {"<CMD>lua require('Navigator').right()<CR>" };
    -- ['n<C-j>'] = {"<CMD>lua require('Navigator').down()<CR>" };

    -- ['n<c-k>'] = { ':TmuxNavigateUp<CR>' };
    -- ['n<c-j>'] = { ':TmuxNavigateDown<CR>' };
    -- ['n<c-h>'] = { ':TmuxNavigateLeft<CR>' };
    -- ['n<c-l>'] = { ':TmuxNavigateRight<CR>' };

    ["n<c-k>"] = { ":wincmd k<CR>" },
    ["n<c-j>"] = { ":wincmd j<CR>" },
    ["n<c-h>"] = { ":wincmd h<CR>" },
    ["n<c-l>"] = { ":wincmd l<CR>" },

    -- disable keys
    ["n<up>"] = { "<nop>" },
    ["n<down>"] = { "<nop>" },
    ["n<left>"] = { "<nop>" },
    ["n<right>"] = { "<nop>" },
    ["i<up>"] = { "<nop>" },
    ["i<down>"] = { "<nop>" },
    ["i<left>"] = { "<nop>" },
    --["i<right>"] = { "<nop>" },
    ["n<space>"] = { "<nop>" },
    ["n<esc>"] = { "<nop>" },

    -- resize splits
    ["n>"] = { ':execute "vertical resize +5"<CR>' },
    ["n<"] = { ':execute "vertical resize -5"<CR>' },
    ["n+"] = { ':execute "resize +5"<CR>' },
    ["n-"] = { ':execute "resize -5"<CR>' },

    -- swap lines
    -- ['n[e'] = { [[:<c-u>execute 'move -1-'. v:count1<cr>]] };
    -- ['n]e'] = { [[:<c-u>execute 'move +'. v:count1<cr>]] };

    -- unimpaired like mappings
    ["n[b"] = { [[:bprevious<cr>]] },
    ["n]b"] = { [[:bnext<cr>]] },
    ["n[q"] = { [[:cprevious<cr>]] },
    ["n]q"] = { [[:cnext<cr>]] },
    ["n[l"] = { [[:lprevious<cr>]] },
    ["n]l"] = { [[:lnext<cr>]] },
    ["n[t"] = { [[:tabprevious<cr>]] },
    ["n]t"] = { [[:tabnext<cr>]] },

    -- paste keeping the default register
    ["v<leader>p"] = { '"_dP' },
    ["v<leader>x"] = { '"_d' },
    ["n<leader>x"] = { '"_x' },

    -- copy & paste to system clipboad
    ["v<leader>y"] = { '"*y', noremap = false },

    -- quickly select text you pasted
    ["ngp"] = { [['`[' . strpart(getregtype(), 0, 1) . '`]']], expr = true },

    -- these work like * and g*, but do not move the cursor and always set hls.
    ["_*"] = { [[:let @/ = '\<'.expand('<cword>').'\>'<bar>set hlsearch<C-M>]] },
    ["_g*"] = { [[:let @/ = expand('<cword>')<bar>set hlsearch<C-M>]] },

    -- goto URL
    ["ngx"] = { [[:call v:lua.g.openURL()<CR>]] },
    ["ngo"] = { "<Plug>(OctoOpenIssueAtCursor)", noremap = false },

    -- TELESCOPE
    --['n<leader>m'] = { [[<cmd>lua require'plugins.telescope'.mru()<CR>]] };
    ["n<leader>m"] = {
      [[<cmd>lua require'telescope'.extensions.frecency.frecency({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>e"] = {
      [[<cmd>lua require'telescope.builtin'.file_browser({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>f"] = {
      [[<cmd>lua require'telescope.builtin'.find_files({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>l"] = {
      [[<cmd>lua require'telescope'.extensions.live_grep_raw.live_grep_raw({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>r"] = { [[<cmd>lua require'plugins.telescope'.reloader()<CR>]] },
    ["n<leader>o"] = {
      [[<cmd>lua require'telescope.builtin'.buffers({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>s"] = {
      [[<cmd>lua require'telescope.builtin'.grep_string({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>gc"] = {
      [[<cmd>lua require'telescope.builtin'.git_commits({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>gf"] = {
      [[<cmd>lua require'telescope.builtin'.git_files({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>gb"] = {
      [[<cmd>lua require'telescope.builtin'.git_branches({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },
    ["n<leader>p"] = {
      [[<cmd>lua require'telescope'.extensions.projects.projects({prompt_title=false,preview_title=false,results_title=false})<CR>]],
    },

    -- GITSIGNS
    ["n[h"] = { "<Plug>(GitGutterPrevHunk)", noremap = false },
    ["n]h"] = { "<Plug>(GitGutterNextHunk)", noremap = false },

    -- VIM-SMOOTHIE
    ["n<c-d>"] = { "<Plug>(SmoothieDownwards)", noremap = false },
    ["n<c-e>"] = { "<Plug>(SmoothieUpwards)", noremap = false },

    -- TRUE-ZEN
    ["n<leader>z"] = { ":TZAtaraxis<CR>" },

    -- NVIM-BUFFERLINE
    ["n<s-l>"] = { ":BufferLineCycleNext<CR>", noremap = false },
    ["n<s-h>"] = { ":BufferLineCyclePrev<CR>", noremap = false },
    -- ['n<leader>]'] = { ':BufferLineMoveNext<CR>', noremap = false; };
    -- ['n<leader>['] = { ':BufferLineMovePrev<CR>', noremap = false; };

    -- NVIM-TREE
    ["nge"] = { [[:NvimTreeFindFileToggle<CR>]] },

    -- GIT-MESSANGER
    ["n<leader>gm"] = { [[<Plug>(git-messenger)]], noremap = false },

    -- DIAL
    ["n<C-a>"] = { [[<Plug>(dial-increment)]] },
    ["n<C-x>"] = { [[<Plug>(dial-decrement)]] },
    ["v<C-a>"] = { [[<Plug>(dial-increment)]] },
    ["v<C-x>"] = { [[<Plug>(dial-decrement)]] },

    -- TROUBLE
    -- ['n<leader>xx'] = { [[<cmd>LspTroubleToggle<cr>]] };
    -- ['n<leader>xw'] = { [[<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>]] };
    -- ['n<leader>xd'] = { [[<cmd>LspTroubleToggle lsp_document_diagnostics<cr>]] };
    -- ['n<leader>xl'] = { [[<cmd>LspTroubleToggle loclist<cr>]] };
    -- ['n<leader>xq'] = { [[<cmd>LspTroubleToggle quickfix<cr>]] };
    -- ['n<leader>xr'] = { [[<cmd>LspTrouble lsp_references<cr>]] };

    -- GOTO-PREVIEW
    ["ngP"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },

    -- LIGHTSPEED
    ["nr"] = { [[<Plug>Lightspeed_s]], noremap = false },
    ["nR"] = { [[<Plug>Lightspeed_A]], noremap = false },

    -- COPILOT
    ["i<C-l>"] = { [[copilot#Accept("\<right>")]], script = true, expr = true },
    ["i<Right>"] = { [[copilot#Accept("\<right>")]], script = true, expr = true },

    -- ZK
    ["n<leader>t"] = { [[<CMD>lua require("pwntester.zk").dailyNote()<CR>]] },

    -- LUASNIP
    --["i<C-k>"] = { [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>']], expr = true },
    --["i<C-l>"] = { [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>']], expr = true },
    ["i<C-j>"] = { [[<CMD>lua require("luasnip").jump(-1)<CR>]] },
    ["s<C-k>"] = { [[<CMD>lua require("luasnip").jump(1)<CR>]] },
    ["s<C-j>"] = { [[<CMD>lua require("luasnip").jump(-1)<CR>]] },
    -- imap <silent><expr> <C-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
    -- imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'
    -- inoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<CR>
    -- snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<CR>
    -- snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<CR>

    -- NVIM-HLSLENS()
    ["nn"] = { [[<CMD>execute('normal! ' . v:count1 . 'n')<CR><CMD>lua require('hlslens').start()<CR>]] },
    ["nN"] = { [[<CMD>execute('normal! ' . v:count1 . 'N')<CR><CMD>lua require('hlslens').start()<CR>]] },
    ["n*"] = { [[*<CMD>lua require('hlslens').start()<CR>]] },
    ["n#"] = { [[#<CMD>lua require('hlslens').start()<CR>]] },
    ["ng*"] = { [[g*<CMD>lua require('hlslens').start()<CR>]] },
    ["ng#"] = { [[g#<CMD>lua require('hlslens').start()<CR>]] },
    -- noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>
    -- noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>
    -- noremap * *<Cmd>lua require('hlslens').start()<CR>
    -- noremap # #<Cmd>lua require('hlslens').start()<CR>
    -- noremap g* g*<Cmd>lua require('hlslens').start()<CR>
    -- noremap g# g#<Cmd>lua require('hlslens').start()<CR>

    -- CODEQL
    ["n<leader>c"] = { [[<Plug>(CodeQLGrepSource)]], noremap = false },
  },
  ["markdown"] = {
    ["i<C-u>"] = { [[<CMD>lua require("pwntester.markdown").pasteLink()<CR>]] },
    ["i<C-b>"] = { [[<CMD>lua require("pwntester.markdown").insertCheckbox()<CR>]] },
    ["i<CR>"] = { [[<CMD>lua require("pwntester.markdown").markdownEnter()<CR>]] },
    ["no"] = { [[<CMD>lua require("pwntester.markdown").markdownO()<CR>]] },
    ["nO"] = { [[<CMD>lua require("pwntester.markdown").markdownShiftO()<CR>]] },
    ["n<leader>i"] = { [[<CMD>lua require("pwntester.markdown").toggleEntries()<CR>]] },
    ["v<leader>i"] = { [[:'<,'>lua require("pwntester.markdown").toggleEntries()<CR>]] },
  },
  ["zk"] = {
    ["n<leader>zi"] = { [[<CMD>lua require("lspconfig").zk.index()<CR>]] },
    ["i<C-n>"] = { [[<CMD>lua require("pwntester.zk").templateNote()<CR>]] },
    ["n<leader>zn"] = {
      [[<CMD>lua require'lspconfig'.zk.new({title = vim.fn.input('Title: '), dir = 'areas/inbox'})<CR>]],
    },
  },
  ["lsp"] = {
    ["ngdc"] = { [[<cmd>lua vim.lsp.buf.declaration()<CR>]] },
    ["ngi"] = { [[<cmd>lua vim.lsp.buf.implementation()<CR>]] },
    ["ngtt"] = { [[<cmd>lua vim.lsp.buf.type_definition()<CR>]] },
    ["ng="] = { [[<cmd>lua vim.lsp.buf.formatting()<CR>]] },
    ["ngic"] = { [[<cmd>lua vim.lsp.buf.incoming_calls()<CR>]] },
    ["ngoc"] = { [[<cmd>lua vim.lsp.buf.outgoing_calls()<CR>]] },
    ["ngK"] = { [[<cmd>lua vim.lsp.buf.hover()<CR>]] },
    ["ngD"] = { [[<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>]] },
    ["ngd"] = { [[<cmd>lua require"telescope.builtin.lsp".definitions()<CR>]] },
    ["ngr"] = { [[<cmd>lua require"telescope.builtin.lsp".references()<CR>]] },
    ["n<C-d>"] = { [[<cmd>lua require"telescope.builtin.lsp".document_symbols()<CR>]] },
    ["n<C-o>"] = { [[<cmd>lua require"plugins.telescope".lsp_dynamic_symbols()<CR>]] },

    -- RENAMER
    ["i<F2>"] = { [[<CMD>lua require("renamer").rename()<CR>]] },
    ["n<leader>rn"] = { [[<CMD>lua require("renamer").rename()<CR>]] },
    ["v<leader>rn"] = { [[<CMD>lua require("renamer").rename()<CR>]] },

    -- ['ngP']     = { [[<Plug>(LspPreviewDefinition)]], noremap = false};
    -- ["ngf"] = { [[<Plug>(LspFinder)]], noremap = false },
    -- ['i<c-s>']  = { [[<Plug>(LspShowSignatureHelp)]], noremap = false};
    -- ["n]e"] = { [[<Plug>(LspNextDiagnostic)]], noremap = false },
    -- ["n[e"] = { [[<Plug>(LspPrevDiagnostic)]], noremap = false },
    -- ["n<A-CR>"] = { [[<Plug>(LspCodeActions)]], noremap = false },
    -- ["v<A-CR>"] = { [[<Plug>(LspRangeCodeActions)]], noremap = false },
  },
  ["treesitter"] = {
    ["n<CR>"] = { [[<Plug>(TsSelInit)]], noremap = false },
    ["x<CR>"] = { [[<Plug>(TsSelScopeIncr)]], noremap = false },
    ["x<Tab>"] = { [[<Plug>(TsSelNodeIncr)]], noremap = false },
    ["x<S-Tab>"] = { [[<Plug>(TsSelNodeDecr)]], noremap = false },
    -- ['xgrd'] = { [[<Plug>(TsSelScopeDecr)]], noremap = false};
    -- ['ngrr'] = { [[<Plug>(TsRename)]]      , noremap = false};
    -- ['ngtd'] = { [[<Plug>(TsGotoDef)]]     , noremap = false};
    -- ['ngnu'] = { [[<Plug>(TsGotoNextUse)]] , noremap = false};
    -- ['ngpu'] = { [[<Plug>(TsGotoPrevUse)]] , noremap = false};
    -- ['ngnD'] = { [[<Plug>(TsListDefs)]]    , noremap = false};
    -- ['n]fs'] = { [[<Plug>(TsGotoNextFuncStart]],   noremap = false};
    -- ['n[f'] = { [[<Plug>(TsGotoPrevFuncStart)]],  noremap = false};
    -- ['n]f'] = { [[<Plug>(TsGotoNextFuncEnd)]],    noremap = false};
    -- ['n[fe'] = { [[<Plug>(TsGotoPrevFuncEnd)]],    noremap = false};
    -- ['n]cs'] = { [[<Plug>(TsGotoNextClassStart)]], noremap = false};
    -- ['n]ce'] = { [[<Plug>(TsGotoNextClassEnd)]],   noremap = false};
    -- ['n[cs'] = { [[<Plug>(TsGotoPrevClassStart)]], noremap = false};
    -- ['n[ce'] = { [[<Plug>(TsGotoPrevClassEnd)]],   noremap = false};
  },
}

return mappings
