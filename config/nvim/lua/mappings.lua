local api = vim.api

local function map(mappings, defaults)
  local opts = vim.fn.deepcopy(defaults)
    for k, v in pairs(mappings) do
        local mode = k:sub(1,1)
        if mode == '_' then mode = '' end
        local lhs = k:sub(2)
        local rhs = v[1]
        v[1] = nil
        for i,j in pairs(v) do opts[i] = j end
        pcall(api.nvim_set_keymap, mode, lhs, rhs, opts)
        v[1] = rhs
    end
end;

local function setup()

  vim.cmd [[ let mapleader = "\<Space>" ]]

  local default_options = { silent = true; noremap = true;}

  local mappings = {

    -- * for visual selected text
    ['v*'] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] };

    -- debug syntax
    ['ngs'] = { ':lua require"functions".debugSyntax()<CR>', noremap = false; };

    -- repeat last search updating search index
    ['nn'] = { '/<CR>' };
    ['nN'] = { '?<CR>' };

    -- escape to normal mode in insert mode
    ['ijk'] = { '<ESC>' };

    -- shifting visual block should keep it selected
    ['v<'] = { '<gv' };
    ['v>'] = { '>gv|' };

    -- automatically jump to end of text you pasted
    ['vy'] = { 'y`' };
    ['vp'] = { 'p`' };
    ['np'] = { 'p`' };

    -- go up/down on visual line
    ['nj'] = { 'gj', noremap = false; };
    ['nk'] = { 'gk', noremap = false; };

    -- go to begining or End of line
    ['nB'] = { '^' };
    ['nE'] = { '$' };

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

    -- window navigation
    ['n<c-j>'] = { '<c-w><c-j>' };
    ['n<c-k>'] = { '<c-w><c-k>' };
    ['n<c-l>'] = { '<C-w><c-l>' };
    ['n<c-h>'] = { '<c-w><c-h>' };

    -- navigate faster
    ['n<leader>j'] = { '12j' };
    ['n<leader>k'] = { '12k' };

    -- paste keeping the default register
    ['v<leader>p'] = { '"_dP' };

    -- copy & paste to system clipboard
    ['v<leader>y'] = { '"*y', noremap = false; };

    -- FUZZY MENU
    -- ['n<leader>f'] = { [[<cmd>lua require'fuzzy'.files()<CR>]] };
    -- ['n<leader>m'] = { [[<cmd>lua require'fuzzy'.mru()<CR>]] };
    -- ['n<leader>o'] = { [[<cmd>lua require'fuzzy'.buffers()<CR>]] };

    -- TELESCOPE
    --['n<leader>f'] = { [[<cmd>lua require'telescope.builtin'.find_files{}<CR>]] };
    ['n<leader>m'] = { [[<cmd>lua require'plugins.telescope'.mru()<CR>]] };
    ['n<leader>f'] = { [[<cmd>lua require'plugins.telescope'.files{}<CR>]] };
    ['n<leader>o'] = { [[<cmd>lua require'plugins.telescope'.buffers{}<CR>]] };
    --['n<leader>o'] = { [[<cmd>lua require'telescope.builtin'.buffers{}<CR>]] };

    -- FZF
    ['n<leader>d'] = { [[:call fzf#vim#files('.', {'options': '--prompt ""'})<Return>]] };

    -- VISTA
    ['n<leader>v'] = { ':Vista<CR>' };
    ['n<leader>vf'] = { ':Vista finder<CR>' };

    -- VIM-SMOOTHIE
    ['n<c-d>'] = { '<Plug>(SmoothieDownwards)', noremap = false; };
    ['n<c-e>'] = { '<Plug>(SmoothieUpwards)', noremap = false; };

    -- VIM-FLOATERM
    ['n<leader>t'] = { ':FloatermNew --height=0.8 --width=0.8<CR>' };

    -- GOYO
    ['n<leader>y'] = { ':Goyo<CR>' };

    -- LAZY-GIT
    ['n<Leader>g'] = { [[:call luaeval('require("window").floating_window({border=false;width_per=0.9;height_per=0.9;})')<bar>call termopen('lazygit')<CR>]] };

    -- VEM-TABLINE
    ['n<s-h>'] = { '<Plug>vem_prev_buffer-', noremap = false; };
    ['n<s-l>'] = { '<Plug>vem_next_buffer-', noremap = false; };
    ['n<leader>['] = { '<Plug>vem_move_buffer_left-', noremap = false; };
    ['n<leader>]'] = { '<Plug>vem_move_buffer_right-', noremap = false; };

    -- DIRVISH
    ['ngE'] = { [[<cmd>lua require'functions'.toggleDirvish()<CR>]] };
    ['nge'] = { [[<cmd>lua require'functions'.toggleDirvish('%')<CR>]] };

    -- these work like * and g*, but do not move the cursor and always set hls.
    ['_*'] = { [[:let @/ = '\<'.expand('<cword>').'\>'<bar>set hlsearch<C-M>]] };
    ['_g*'] = { [[:let @/ = expand('<cword>')<bar>set hlsearch<C-M>]] };

    -- move around command line wildmenu
    ['c<c-j>'] = { '<right>' };
    ['c<c-k>'] = { '<left>' };
    ['c<c-h>'] = { '<space><bs><left>' };
    ['c<c-l>'] = { '<space><bs><right>' };

  }

  map(mappings, default_options)

  local expr_mappings = {
    -- quickly select text you pasted
    ['ngp'] = { [['`[' . strpart(getregtype(), 0, 1) . '`]']] };

    -- jump to next/previous search match
    ['c<C-j>'] = { [[getcmdtype() == "/" <bar><bar> getcmdtype() == "?" ? "<C-g>" : "<C-j>"]] };
    ['c<C-k>'] = { [[getcmdtype() == "/" <bar><bar> getcmdtype() == "?" ? "<C-t>" : "<C-j>"]] };

    -- SNIPPETS.NVIM
    ['i<CR>'] = { [[pumvisible() ? "\<c-y>\<cr>" : "\<CR>"]] };
    ['i<c-j>'] = { [[pumvisible() ? "\<C-n>" : "\<cmd>lua return require'snippets'.expand_or_advance()<CR>"]] };
    ['i<c-k>'] = { [[pumvisible() ? "\<C-p>" : "\<cmd>lua return require'snippets'.advance_snippet(-1)<CR>" ]] };

  }
  map(expr_mappings, { expr = true; })

end

return {
  setup = setup;
}
