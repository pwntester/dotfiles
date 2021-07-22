--local npairs = require('nvim-autopairs')
local vim = vim

local function map(mappings, defaults)
  for k, v in pairs(mappings) do
    local opts = vim.fn.deepcopy(defaults)
    local mode = k:sub(1,1)
    if mode == '_' then mode = '' end
    local lhs = k:sub(2)
    local rhs = v[1]
    v[1] = nil

    -- merge default options and individual ones
    for i,j in pairs(v) do opts[i] = j end

    -- for <expr> mappings, discard all options except `noremap`
    -- probably needed for <script> or other modifiers that need to be first
    if opts.expr then
      local noremap_opt = opts['noremap']
      opts = { expr = true; noremap = noremap_opt }
    end

    -- apply settings
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)

    -- restore
    --v[1] = rhs
  end
end

local mappings = {

  -- * for visual selected text
  ['v*'] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] };

  -- repeat last search updating search index
  ['nn'] = { '/<CR>' };
  ['nN'] = { '?<CR>' };

  -- escape to normal mode
  ['ijk'] = { '<ESC>' };
  ['tjk'] = { [[<C-\><C-n>]] };

  -- shifting visual block should keep it selected
  ['v<'] = { '<gv' };
  ['v>'] = { '>gv|' };

  -- automatically jump to end of text you pasted
  ['vy'] = { 'y`]' };
  ['vp'] = { 'p`]' };
  ['np'] = { 'p`]' };

  -- go up/down on visual line
  ['vj'] = { 'gj', noremap = false; };
  ['vk'] = { 'gk', noremap = false; };
  ['nj'] = { [[ (v:count? 'j' : 'gj') ]], expr = true; };
  ['nk'] = { [[ (v:count? 'k' : 'gk') ]], expr = true; };

  -- go to begining or end of line
  ['nB'] = { '^' };
  ['nE'] = { '$' };

  -- move between windows
  ['n<C-p>'] = { '<Plug>(choosewin)', noremap = false; };

  -- ['n<C-h>'] = {"<CMD>lua require('Navigator').left()<CR>" };
  -- ['n<C-k>'] = {"<CMD>lua require('Navigator').up()<CR>" };
  -- ['n<C-l>'] = {"<CMD>lua require('Navigator').right()<CR>" };
  -- ['n<C-j>'] = {"<CMD>lua require('Navigator').down()<CR>" };

  -- ['n<c-k>'] = { ':TmuxNavigateUp<CR>' };
  -- ['n<c-j>'] = { ':TmuxNavigateDown<CR>' };
  -- ['n<c-h>'] = { ':TmuxNavigateLeft<CR>' };
  -- ['n<c-l>'] = { ':TmuxNavigateRight<CR>' };

  ['n<c-k>'] = { ':wincmd k<CR>' };
  ['n<c-j>'] = { ':wincmd j<CR>' };
  ['n<c-h>'] = { ':wincmd h<CR>' };
  ['n<c-l>'] = { ':wincmd l<CR>' };

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
  -- ['n[e'] = { [[:<c-u>execute 'move -1-'. v:count1<cr>]] };
  -- ['n]e'] = { [[:<c-u>execute 'move +'. v:count1<cr>]] };

  -- unimpaired like mappings
  ['n[b'] = { [[:bprevious<cr>]] };
  ['n]b'] = { [[:bnext<cr>]] };
  ['n[q'] = { [[:cprevious<cr>]] };
  ['n]q'] = { [[:cnext<cr>]] };
  ['n[l'] = { [[:lprevious<cr>]] };
  ['n]l'] = { [[:lnext<cr>]] };
  ['n[t'] = { [[:tabprevious<cr>]] };
  ['n]t'] = { [[:tabnext<cr>]] };

  -- paste keeping the default register
  ['v<leader>p'] = { '"_dP' };
  ['v<leader>x'] = { '"_d' };
  ['n<leader>x'] = { '"_x' };

  -- copy & paste to system clipboad
  ['v<leader>y'] = { '"*y', noremap = false; };

  -- quickly select text you pasted
  ['ngp'] = { [['`[' . strpart(getregtype(), 0, 1) . '`]']], expr = true; };

  -- these work like * and g*, but do not move the cursor and always set hls.
  ['_*'] = { [[:let @/ = '\<'.expand('<cword>').'\>'<bar>set hlsearch<C-M>]] };
  ['_g*'] = { [[:let @/ = expand('<cword>')<bar>set hlsearch<C-M>]] };

  -- goto URL
  ['ngx'] = { [[:call v:lua.g.openURL()<CR>]] };
  ['ngo'] = { '<Plug>(OctoOpenIssueAtCursor)', noremap = false; };

  -- TELESCOPE
  --['n<leader>m'] = { [[<cmd>lua require'plugins.telescope'.mru()<CR>]] };
  ['n<leader>m'] = { [[<cmd>lua require'telescope'.extensions.frecency.frecency({prompt_title=false,preview_title=false,results_title=false})<CR>]]};
  ['n<leader>e'] = { [[<cmd>lua require'telescope.builtin'.file_browser({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>f'] = { [[<cmd>lua require'telescope.builtin'.find_files({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>l'] = { [[<cmd>lua require'telescope.builtin'.live_grep({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>r'] = { [[<cmd>lua require'plugins.telescope'.reloader()<CR>]] };
  ['n<leader>o'] = { [[<cmd>lua require'telescope.builtin'.buffers({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  --['n<leader>s'] = { [[<cmd>lua require'telescope.builtin'.treesitter({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>s'] = { [[<cmd>lua require'telescope.builtin'.grep_string({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>gc'] = { [[<cmd>lua require'telescope.builtin'.git_commits({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>gf'] = { [[<cmd>lua require'telescope.builtin'.git_files({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>gb'] = { [[<cmd>lua require'telescope.builtin'.git_branches({prompt_title=false,preview_title=false,results_title=false})<CR>]] };
  ['n<leader>p'] = { [[<cmd>lua require'telescope'.extensions.project.project{change_dir = true}<CR>]] };

  -- GITSIGNS
  ['n[h'] = { '<Plug>(GitGutterPrevHunk)', noremap = false; };
  ['n]h'] = { '<Plug>(GitGutterNextHunk)', noremap = false; };


  -- VIM-SMOOTHIE
  ['n<c-d>'] = { '<Plug>(SmoothieDownwards)', noremap = false; };
  ['n<c-e>'] = { '<Plug>(SmoothieUpwards)', noremap = false; };

  -- GOYO
  ['n<leader>y'] = { ':Goyo<CR>' };

  -- NVIM-BUFFERLINE
  ['n<s-l>'] = { ':BufferLineCycleNext<CR>', noremap = false; };
  ['n<s-h>'] = { ':BufferLineCyclePrev<CR>', noremap = false; };
  -- ['n<leader>]'] = { ':BufferLineMoveNext<CR>', noremap = false; };
  -- ['n<leader>['] = { ':BufferLineMovePrev<CR>', noremap = false; };

  -- NVIM-TREE
  ['ngE'] = { [[:NvimTreeToggle<CR>]] };
  ['nge'] = { [[:NvimTreeFindFile<CR>]] };

  -- GIT-MESSANGER
  ['n<leader>gm'] = { [[<Plug>(git-messenger)]], noremap = false };

  -- DIAL
  ['n<C-a>'] = { [[<Plug>(dial-increment)]] };
  ['n<C-x>'] = { [[<Plug>(dial-decrement)]] };
  ['v<C-a>'] = { [[<Plug>(dial-increment)]] };
  ['v<C-x>'] = { [[<Plug>(dial-decrement)]] };

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
  ['ngP'] = {"<cmd>lua require('goto-preview').goto_preview_definition()<CR>" };

  -- LSP
  ['ng=']     = { [[<Plug>(LspFormat)]], noremap = false};

  ['ngD']     = { [[<Plug>(LspShowLineDiagnostics)]], noremap = false};
  --['ngP']     = { [[<Plug>(LspPreviewDefinition)]], noremap = false};

  ['ngd']     = { [[<Plug>(LspGotoDef)]], noremap = false};
  ['ngi']     = { [[<Plug>(LspGotoImpl)]], noremap = false};
  ['ngdc']    = { [[<Plug>(LspGotoDecl)]], noremap = false};

  ['ngr']     = { [[<Plug>(LspShowReferences)]], noremap = false};
  ['ngf']     = { [[<Plug>(LspFinder)]], noremap = false};

  ['ngK']     = { [[<Plug>(LspHover)]], noremap = false};

  ['ngcr']    = { [[<Plug>(LspRename)]], noremap = false};
  ['ngR']     = { [[<cmd>lua require('lspsaga.rename').rename()<CR>]], noremap = false};

  ['i<c-s>']  = { [[<Plug>(LspShowSignatureHelp)]], noremap = false};

  ['n]e']     = { [[<Plug>(LspNextDiagnostic)]] , noremap = false};
  ['n[e']     = { [[<Plug>(LspPrevDiagnostic)]] , noremap = false};

  ['n<A-CR>'] = { [[<Plug>(LspCodeActions)]], noremap = false};
  ['v<A-CR>'] = { [[<Plug>(LspRangeCodeActions)]], noremap = false};

  ['n<C-d>']  = { [[<Plug><LspDocumentSymbol)]], noremap = false};
  ['n<C-o>']  = { [[<Plug><LspWorkspaceSymbol)]], noremap = false};

  ['ngtt']    = { [[<Plug>(LspGotoTypeDef)]], noremap = false};
  ['ngic']    = { [[<Plug>(LspIncomingCalls)]], noremap = false};
  ['ngoc']    = { [[<Plug>(LspOutgoingCalls)]], noremap = false};
}

-- PUM + COMPLE + VSNIP
_G.next_complete = function(mode)
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, false, true)
  elseif mode == "c" then
    return vim.api.nvim_replace_termcodes("<down>", true, false, true)
  else
    return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
  end
end
_G.prev_complete = function(mode)
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, false, true)
  elseif mode == "c" then
    return vim.api.nvim_replace_termcodes("<up>", true, false, true)
  else
    return vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
  end
end
vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.next_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("i", "<down>", "v:lua.next_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-k>", "v:lua.prev_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("i", "<up>", "v:lua.prev_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.next_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("s", "<down>", "v:lua.next_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.prev_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("s", "<up>", "v:lua.prev_complete()", {noremap = true, expr = true})
vim.api.nvim_set_keymap("c", "<C-j>", "v:lua.next_complete('c')", {noremap = true, expr = true})
vim.api.nvim_set_keymap("c", "<C-k>", "v:lua.prev_complete('c')", {noremap = true, expr = true})
vim.api.nvim_set_keymap("c", "<down>", "v:lua.next_complete('c')", {noremap = true, expr = true})
vim.api.nvim_set_keymap("c", "<up>", "v:lua.prev_complete('c')", {noremap = true, expr = true})

-- jump to next/previous search match on search mode
-- ['c<C-j>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-g>' : '<C-j>']], expr = true; };
-- ['c<C-k>'] = { [[getcmdtype() == '/' <bar><bar> getcmdtype() == '?' ? '<C-t>' : '<C-k>']], expr = true; };


--vim.g.completion_confirm_key = ""
-- _G.completion_confirm=function()
--   if vim.fn.pumvisible() ~= 0  then
--     if vim.fn.complete_info()["selected"] ~= -1 then
--       vim.fn["compe#confirm"]()
--       return npairs.esc("")
--       --return npairs.esc("<c-y>")
--     else
--       --return npairs.esc("<CR>")
--       return npairs.check_break_line_char()
--     end
--   else
--     --return npairs.esc("<CR>")
--     return npairs.check_break_line_char()
--   end
-- end
--vim.api.nvim_set_keymap("i", "<CR>",  "v:lua.completion_confirm()", {expr = true})

vim.cmd [[tnoremap <Esc> <C-\><C-n>]]

vim.cmd [[let mapleader = "\<Space>"]]

map(mappings, { silent = true; noremap = true; })

