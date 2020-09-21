require'nvim_utils'

local function setup()

  vim.cmd [[ let mapleader = "\<Space>" ]]

  local default_options = { silent = true; }

  local mappings = {

    -- debug syntax
    ['ngs'] = { ':lua require"functions".debugSyntax()<CR>', noremap = false; };

    -- repeat last search updating search index
    ['nn'] = { '/<CR>', noremap = true; };
    ['nN'] = { '/<CR>', noremap = true; };

    -- * for visual selected text
    ['v*'] = { [[y/ 0 bytes scape(@",'/\')<CR><CR>]], noremap = true; };

    -- these work like * and g*, but do not move the cursor and always set hls.
    -- map * :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>
    -- map g* :let @/ = expand('<cword>')\|set hlsearch<C-M>

    -- escape to normal mode in insert mode
    ['ijk'] = { '<ESC>', noremap = true; };

    -- shifting visual block should keep it selected
    ['v<'] = { '<gv', noremap = true; };
    ['v>'] = { '>gv|', noremap = true; };

    -- automatically jump to end of text you pasted
    ['vy'] = { 'y`', noremap = true; };
    ['vp'] = { 'p`', noremap = true; };
    ['np'] = { 'p`', noremap = true; };

    -- quickly select text you pasted
    -- nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

    -- go up/down on visual line
    ['nj'] = { 'gj', noremap = false; };
    ['nk'] = { 'gk', noremap = false; };

    -- go to begining or End of line
    ['nB'] = { '^', noremap = true; };
    ['nE'] = { '$', noremap = true; };

    -- disable keys
    ['n<up>'] = { '<nop>', noremap = true; };
    ['n<down>'] = { '<nop>', noremap = true; };
    ['n<left>'] = { '<nop>', noremap = true; };
    ['n<right>'] = { '<nop>', noremap = true; };
    ['i<up>'] = { '<nop>', noremap = true; };
    ['i<down>'] = { '<nop>', noremap = true; };
    ['i<left>'] = { '<nop>', noremap = true; };
    ['i<right>'] = { '<nop>', noremap = true; };
    ['n<space>'] = { '<nop>', noremap = true; };
    ['n<esc>'] = { '<nop>', noremap = true; };

    -- save one keystroke
    ['n;'] = { ':', noremap = true; };

    -- resize splits
    ['n>'] = { ':execute "vertical resize +5"<CR>', noremap = true; };
    ['n<'] = { ':execute "vertical resize -5"<CR>', noremap = true; };
    ['n+'] = { ':execute "resize +5"<CR>', noremap = true; };
    ['n-'] = { ':execute "resize -5"<CR>', noremap = true; };

    -- move around command line wildmenu
    -- cnoremap <C-k> <LEFT>
    -- cnoremap <C-j> <RIGHT>
    -- cnoremap <C-h> <Space><BS><Left>
    -- cnoremap <C-l> <Space><BS><Right>

    -- window navigation
    ['n<c-j>'] = { '<c-w><c-j>', noremap = true; };
    ['n<c-k>'] = { '<c-w><c-k>', noremap = true; };
    ['n<c-l>'] = { '<C-w><c-l>', noremap = true; };
    ['n<c-h>'] = { '<c-w><c-h>', noremap = true; };

    -- navigate faster
    ['n<leader>j'] = { '12j', noremap = true; };
    ['n<leader>k'] = { '12k', noremap = true; };

    -- paste keeping the default register
    ['v<leader>p'] = { '"_dP', noremap = true; };

    -- copy & paste to system clipboard
    ['v<leader>y'] = { '"*y', noremap = false; };

    -- FUZZY MENU
    ['n<leader>f'] = { require'fuzzy'.files, noremap = true; };
    ['n<leader>m'] = { require'fuzzy'.mru, noremap = true; };
    ['n<leader>o'] = { require'fuzzy'.buffers, noremap = true; };

    -- FZF
    ['n<leader>d'] = { [[:call fzf#vim#files('.', {'options': '--prompt ""'})<Return>]], noremap = true; };

    -- VISTA
    ['n<leader>v'] = { ':Vista<CR>', noremap = true; };
    ['n<leader>vf'] = { ':Vista finder<CR>', noremap = true; };

    -- VIM-SMOOTHIE
    ['n<c-d>'] = { '<Plug>(SmoothieDownwards)', noremap = false; };
    ['n<c-e>'] = { '<Plug>(SmoothieUpwards)', noremap = false; };

    -- VIM-FLOATERM
    ['n<leader>t'] = { ':FloatermNew --height=0.8 --width=0.8<CR>', noremap = true; };

    -- GOYO
    ['n<leader>y'] = { ':Goyo<CR>', noremap = true; };

    -- LAZY-GIT
    ['n<Leader>g'] = { function()
      require('window').floating_window({border=false;width_per=0.9;height_per=0.9;})
      vim.fn.termopen('lazygit')
    end, noremap = true; };

    -- VEM-TABLINE
    ['n<s-h>'] = { '<Plug>vem_prev_buffer-', noremap = false; };
    ['n<s-l>'] = { '<Plug>vem_next_buffer-', noremap = false; };
    ['n<leader>['] = { '<Plug>vem_move_buffer_left-', noremap = false; };
    ['n<leader>]'] = { '<Plug>vem_move_buffer_right-', noremap = false; };

    -- DIRVISH
    ['ngE'] = { function() require'functions'.toggleDirvish() end, noremap = true; };
    ['nge'] = { function() require'functions'.toggleDirvish('%') end, noremap = true; };
  }

  -- SNIPPETS.NVIM
  vim.cmd [[ inoremap <silent><expr> <Return> pumvisible() ? "\<c-y>\<cr>" : "\<CR>" ]]
  vim.cmd [[ inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<cmd>lua return require'snippets'.expand_or_advance()<CR>" ]]
  vim.cmd [[ inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : "\<cmd>lua return require'snippets'.expand_or_advance(-1)<CR>" ]]

  nvim_apply_mappings(mappings, default_options)
end

return {
  setup = setup;
}
