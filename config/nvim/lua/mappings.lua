local vim = vim

local function map(mappings, defaults)
  for k, v in pairs(mappings) do
    local opts = vim.fn.deepcopy(defaults)
    local mode = k:sub(1, 1)
    if mode == "_" then
      mode = ""
    end
    local lhs = k:sub(2)
    local rhs = v[1]
    v[1] = nil

    -- merge default options and individual ones
    for i, j in pairs(v) do
      opts[i] = j
    end

    -- for <expr> mappings, discard all options except `noremap`
    -- probably needed for <script> or other modifiers that need to be first
    if opts.expr then
      local noremap_opt = opts["noremap"]
      opts = { expr = true, noremap = noremap_opt }
    end

    -- apply settings
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)

    -- restore
    --v[1] = rhs
  end
end

local mappings = {

  -- * for visual selected text
  ["v*"] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] },

  -- repeat last search updating search index
  ["nn"] = { "/<CR>" },
  ["nN"] = { "?<CR>" },

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
  ["i<right>"] = { "<nop>" },
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
    [[<cmd>lua require'telescope.builtin'.live_grep({prompt_title=false,preview_title=false,results_title=false})<CR>]],
  },
  ["n<leader>r"] = { [[<cmd>lua require'plugins.telescope'.reloader()<CR>]] },
  ["n<leader>o"] = {
    [[<cmd>lua require'telescope.builtin'.buffers({prompt_title=false,preview_title=false,results_title=false})<CR>]],
  },
  --['n<leader>s'] = { [[<cmd>lua require'telescope.builtin'.treesitter({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
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

  -- TRUEZEN
  ["n<leader>z"] = { ":TZAtaraxis<CR>" },

  -- NVIM-BUFFERLINE
  ["n<s-l>"] = { ":BufferLineCycleNext<CR>", noremap = false },
  ["n<s-h>"] = { ":BufferLineCyclePrev<CR>", noremap = false },
  -- ['n<leader>]'] = { ':BufferLineMoveNext<CR>', noremap = false; };
  -- ['n<leader>['] = { ':BufferLineMovePrev<CR>', noremap = false; };

  -- NVIM-TREE
  ["nge"] = { [[:NvimTreeToggle<CR>]] },
  --['nge'] = { [[:NvimTreeFindFile<CR>]] };

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
  -- ['n]fs'] = { [[<Plug>(TsGotoNextFuncStart]],   noremap = false};
  -- ['n[f'] = { [[<Plug>(TsGotoPrevFuncStart)]],  noremap = false};
  -- ['n]f'] = { [[<Plug>(TsGotoNextFuncEnd)]],    noremap = false};
  -- ['n[fe'] = { [[<Plug>(TsGotoPrevFuncEnd)]],    noremap = false};
  -- ['n]cs'] = { [[<Plug>(TsGotoNextClassStart)]], noremap = false};
  -- ['n]ce'] = { [[<Plug>(TsGotoNextClassEnd)]],   noremap = false};
  -- ['n[cs'] = { [[<Plug>(TsGotoPrevClassStart)]], noremap = false};
  -- ['n[ce'] = { [[<Plug>(TsGotoPrevClassEnd)]],   noremap = false};

  -- GOTO-PREVIEW
  ["ngP"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },

  -- LSP
  ["ng="] = { [[<Plug>(LspFormat)]], noremap = false },

  ["ngD"] = { [[<Plug>(LspShowLineDiagnostics)]], noremap = false },
  --['ngP']     = { [[<Plug>(LspPreviewDefinition)]], noremap = false};

  ["ngd"] = { [[<Plug>(LspGotoDef)]], noremap = false },
  ["ngi"] = { [[<Plug>(LspGotoImpl)]], noremap = false },
  ["ngdc"] = { [[<Plug>(LspGotoDecl)]], noremap = false },

  ["ngr"] = { [[<Plug>(LspShowReferences)]], noremap = false },
  ["ngf"] = { [[<Plug>(LspFinder)]], noremap = false },

  ["ngK"] = { [[<Plug>(LspHover)]], noremap = false },

  ["ngcr"] = { [[<Plug>(LspRename)]], noremap = false },
  ["ngR"] = { [[<cmd>lua require('lspsaga.rename').rename()<CR>]], noremap = false },

  --['i<c-s>']  = { [[<Plug>(LspShowSignatureHelp)]], noremap = false};

  ["n]e"] = { [[<Plug>(LspNextDiagnostic)]], noremap = false },
  ["n[e"] = { [[<Plug>(LspPrevDiagnostic)]], noremap = false },

  ["n<A-CR>"] = { [[<Plug>(LspCodeActions)]], noremap = false },
  ["v<A-CR>"] = { [[<Plug>(LspRangeCodeActions)]], noremap = false },

  ["n<C-d>"] = { [[<Plug><LspDocumentSymbol)]], noremap = false },
  ["n<C-o>"] = { [[<Plug><LspWorkspaceSymbol)]], noremap = false },

  ["ngtt"] = { [[<Plug>(LspGotoTypeDef)]], noremap = false },
  ["ngic"] = { [[<Plug>(LspIncomingCalls)]], noremap = false },
  ["ngoc"] = { [[<Plug>(LspOutgoingCalls)]], noremap = false },

  -- MARKDOWN
  -- TODO: move to markdown.vim
  ["n<leader>t"] = { [[<cmd>lua require('markdown').toggleCheckboxes()<CR>]], noremap = false },
  ["v<leader>t"] = { [[:'<,'>lua require('markdown').toggleCheckboxes()<CR>]], noremap = false },
  ["n<leader>i"] = { [[<cmd>lua require('markdown').toggleBullets()<CR>]], noremap = false },
  ["v<leader>i"] = { [[:'<,'>lua require('markdown').toggleBullets()<CR>]], noremap = false },

  -- ZK
  ["nS591"] = { [[:call v:lua.g.DailyNote()<CR>]], noremap = true }, -- cmd + t (today)
  ["nU678"] = { [[<Plug>(ZKFollowLink)]], noremap = false }, -- cmd + enter
  ["vU678"] = { [[<Plug>(ZKCreateNoteFromSelection)]], noremap = false }, -- cmd + enter
  ["n<leader>zi"] = { [[<Plug>(ZKIndex)]], noremap = false },
  ["n<leader>zn"] = { [[<Plug>(ZKNewNote)]], noremap = false },

  -- LIGHTSPEED
  ["nr"] = { [[<Plug>Lightspeed_s]], noremap = false },
  ["nR"] = { [[<Plug>Lightspeed_A]], noremap = false },

  -- COPILOT
  ["i<C-]>"] = { [[copilot#Accept("")]], silent = true, expr = true, noremap = true },

  -- ZK.NVIM
  -- ['n<leader>n'] =  { [[<cmd>lua require('telescope').extensions.zk.zk_notes()<CR>]],     noremap = false; };
  -- ['n<leader>zg'] = { [[<cmd>lua require('telescope').extensions.zk.zk_grep()<CR>]],      noremap = false; };
  -- ['n<leader>zb'] = { [[<cmd>lua require('telescope').extensions.zk.zk_backlinks()<CR>]], noremap = false; };
}

-- jump to next/previous search match on search mode
-- ['c<C-j>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-g>' : '<C-j>']], expr = true; };
-- ['c<C-k>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-t>' : '<C-k>']], expr = true; };

vim.cmd [[tnoremap <Esc> <C-\><C-n>]]
vim.cmd [[let mapleader = "\<Space>"]]

-- RENAMER
vim.api.nvim_set_keymap("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>rn",
  '<cmd>lua require("renamer").rename()<cr>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rn",
  '<cmd>lua require("renamer").rename()<cr>',
  { noremap = true, silent = true }
)

-- LUASNIP
vim.cmd [[
  imap <silent><expr> <C-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<CR>
  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'
  snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

-- NVIM-HLSLENS()
vim.cmd [[
  noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>
  noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>
  noremap * *<Cmd>lua require('hlslens').start()<CR>
  noremap # #<Cmd>lua require('hlslens').start()<CR>
  noremap g* g*<Cmd>lua require('hlslens').start()<CR>
  noremap g# g#<Cmd>lua require('hlslens').start()<CR>
]]

map(mappings, { silent = true, noremap = true })
