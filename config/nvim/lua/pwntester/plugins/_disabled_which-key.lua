local wk = require('which-key')

local M = {}

function M.setup()
  wk.setup({
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  })
  wk.register({
    ['<leader>'] = {
      b = {
        name = 'TEST PREFIX',
      },
    }
  })

  -- wk.register({
  --   ['<leader>'] = {
  --     d = {
  --       f = 'treesitter: peek function definition',
  --       F = 'treesitter: peek class definition',
  --     },
  --     n = {
  --       name = '+new',
  --       f = 'create a new file',
  --       s = 'create new file in a split',
  --     },
  --     m = 'recent files',
  --     p = {
  --       name = '+packer',
  --       c = 'clean',
  --       s = 'sync',
  --     },
  --     q = {
  --       name = '+quit',
  --       w = 'close window (and buffer)',
  --       q = 'delete buffer',
  --     },
  --     g = 'grep word under the cursor',
  --     l = {
  --       name = '+list',
  --       i = 'toggle location list',
  --       s = 'toggle quickfix',
  --     },
  --     e = {
  --       name = '+edit',
  --       v = 'open vimrc in a vertical split',
  --       p = 'open plugins file in a vertical split',
  --       z = 'open zshrc in a vertical split',
  --       t = 'open tmux config in a vertical split',
  --     },
  --     o = {
  --       name = '+only',
  --       n = 'close all other buffers',
  --     },
  --     t = {
  --       name = '+tab',
  --       c = 'tab close',
  --       n = 'tab edit current buffer',
  --     },
  --     sw = 'swap buffers horizontally',
  --     so = 'source current buffer',
  --     sv = 'source init.vim',
  --     U = 'uppercase all word',
  --     ['<CR>'] = 'repeat previous macro',
  --     [','] = 'go to previous buffer',
  --     ['='] = 'make windows equal size',
  --     [')'] = 'wrap with parens',
  --     ['}'] = 'wrap with braces',
  --     ['"'] = 'wrap with double quotes',
  --     ["'"] = 'wrap with single quotes',
  --     ['`'] = 'wrap with back ticks',
  --     ['['] = 'replace cursor word in file',
  --     [']'] = 'replace cursor word in line',
  --   },
  -- })


end

return M
