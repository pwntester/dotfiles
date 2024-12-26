--# selene: allow(mixed_table)
local vim = vim
local g = require "pwntester.globals"
return {
  ["all"] = {

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

    ["v*"] = {
      [[y/\V<C-R>=escape(@",'/\')<CR><CR>]],
      desc = "Search visual selection",
    },

    -- escape to normal mode
    ["ijk"] = {
      "<ESC>",
      desc = "Escape to normal mode",
    },
    ["tjk"] = {
      [[<C-\><C-n>]],
      desc = "Escape to normal mode",
    },

    -- shifting visual block should keep it selected
    ["v<"] = {
      "<gv",
      desc = "Shift visual block left",
    },
    ["v>"] = {
      ">gv|",
      desc = "Shift visual block right",
    },

    -- automatically jump to end of text you pasted
    --["vy"] = { "y`]" },
    ["vp"] = {
      "p`]",
      desc = "Paste and jump to end of text",
    },
    ["np"] = {
      "p`]",
      desc = "Paste and jump to end of text",
    },

    -- go up/down on visual line
    ["vj"] = {
      "gj",
      noremap = false,
      desc = "Go down on visual mode",
    },
    ["vk"] = {
      "gk",
      noremap = false,
      desc = "Go up on visual mode",
    },
    ["nj"] = {
      [[ (v:count? 'j' : 'gj') ]],
      expr = true,
      desc = "Go down on normal mode",
    },
    ["nk"] = {
      [[ (v:count? 'k' : 'gk') ]],
      expr = true,
      desc = "Go up on normal mode",
    },

    -- go to begining or end of line
    ["nB"] = {
      "^",
      desc = "Go to begining of line",
    },
    ["nE"] = {
      "$",
      desc = "Go to end of line",
    },

    -- unimpaired like mappings
    ["n[b"] = {
      [[:bprevious<CR>]],
      desc = "Previous buffer",
    },
    ["n]b"] = {
      [[:bnext<CR>]],
      desc = "Next buffer",
    },
    ["n[q"] = {
      [[:cprevious<CR>]],
      desc = "Previous QF entry",
    },
    ["n]q"] = {
      [[:cnext<CR>]],
      desc = "Next QF entry",
    },
    ["n[l"] = {
      [[:lprevious<CR>]],
      desc = "Previous LOC entry",
    },
    ["n]l"] = {
      [[:lnext<CR>]],
      desc = "Next LOC entry",
    },
    ["n[t"] = {
      [[:tabprevious<CR>]],
      desc = "Previous tab",
    },
    ["n]t"] = {
      [[:tabnext<CR>]],
      desc = "Next tab",
    },

    -- paste keeping the default register
    ["v<leader>p"] = {
      '"_dP',
      desc = "Paste keeping the default register",
    },
    ["v<leader>x"] = {
      '"_d',
      desc = "Cut keeping the default register",
    },
    ["n<leader>x"] = {
      '"_x',
      desc = "Cut keeping the default register",
    },

    -- copy & paste to system clipboad
    ["v<leader>y"] = {
      '"*y',
      noremap = false,
      desc = "Copy to system clipboard",
    },

    -- quickly select text you pasted
    ["ngp"] = {
      [['`[' . strpart(getregtype(), 0, 1) . '`]']],
      expr = true,
      desc = "Select text pasted",
    },

    -- goto URL
    ["ngx"] = {
      g.openURL,
      desc = "Go to URL",
    },
    ["ngo"] = {
      "<Plug>(OctoOpenIssueAtCursor)",
      noremap = false,
      desc = "Open URL in Octo",
    },

    -- COMMENT.NVIM
    ["ngc"] = {
      "<Plug>(comment_toggle_linewise_visual)",
      noremap = false,
      desc = "Coment linewise",
    },
    ["ngb"] = {
      "<Plug>(comment_toggle_blockwise)",
      noremap = false,
      desc = "Coment blockwise",
    },

    -- CHATGPT
    ["v<leader>gc"] = { [[:ChatGPTRun grammar_correction<CR>]] },

    -- GITSIGNS
    ["n[h"] = {
      "<Plug>(GitGutterPrevHunk)",
      noremap = false,
      desc = "Previous hunk",
    },
    ["n]h"] = {
      "<Plug>(GitGutterNextHunk)",
      noremap = false,
      desc = "Next Hunk",
    },

    -- TROUBLE
    ["n<leader>xx"] = {
      [[<cmd>LspTroubleToggle<cr>]],
      desc = "Toggle LSP trouble",
    },
    ["n<leader>xw"] = {
      [[<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>]],
      desc = "Toggle LSP workspace diagnostics",
    },
    ["n<leader>xd"] = {
      [[<cmd>LspTroubleToggle lsp_document_diagnostics<cr>]],
      desc = "Toggle LSP document diagnostics",
    },
    ["n<leader>xl"] = {
      [[<cmd>LspTroubleToggle loclist<cr>]],
      desc = "Toggle LSP loclist",
    },
    ["n<leader>xq"] = {
      [[<cmd>LspTroubleToggle quickfix<cr>]],
      desc = "Toggle LSP quickfix",
    },
    ["n<leader>xr"] = {
      [[<cmd>LspTrouble lsp_references<cr>]],
      desc = "LSP references",
    },
  },

  ["lsp"] = {
    ["ngdc"] = {
      vim.lsp.buf.declaration,
      desc = "Goto declaration",
    },
    ["ngi"] = {
      vim.lsp.buf.implementation,
      desc = "Goto implementation",
    },
    ["ngtt"] = {
      vim.lsp.buf.type_definition,
      desc = "Goto type definition",
    },
    --[[ ["ng="] = { ]]
    --[[   vim.lsp.buf.formatting, ]]
    --[[   desc = "Format document" ]]
    --[[ }, ]]
    ["ngic"] = {
      vim.lsp.buf.incoming_calls,
      desc = "Incoming calls",
    },
    ["ngoc"] = {
      vim.lsp.buf.outgoing_calls,
      desc = "Outcoming calls",
    },
    ["ngK"] = {
      vim.lsp.buf.hover,
      desc = "Hover",
    },
    ["ngD"] = {
      function()
        vim.diagnostic.open_float(0, { scope = "line", border = "single" })
      end,
      desc = "Show diagnostics",
    },
    ["ngd"] = {
      function()
        if not vim.g.vscode then
          require("telescope.builtin").lsp_definitions()
        end
      end,
      desc = "Goto definition",
    },
    ["ngr"] = {
      function()
        if not vim.g.vscode then
          require("telescope.builtin").lsp_references()
        end
      end,
      desc = "Goto references",
    },
  },
  -- ["treesitter"] = {
  --   ["n<CR>"] = {
  --     [[<Plug>(TsSelInit)]],
  --     noremap = false,
  --     desc = "Select context incrementally",
  --   },
  --   ["x<CR>"] = {
  --     [[<Plug>(TsSelScopeIncr)]],
  --     noremap = false,
  --     desc = "Select context incrementally",
  --   },
  --   ["x<Tab>"] = {
  --     [[<Plug>(TsSelNodeIncr)]],
  --     noremap = false,
  --     desc = "Select node incrementally",
  --   },
  --   ["x<S-Tab>"] = {
  --     [[<Plug>(TsSelNodeDecr)]],
  --     noremap = false,
  --     desc = "Select node incrementally",
  --   },
  -- },
  ["gitconflict"] = {
    ["n[n"] = { [[<Plug>(git-conflict-prev-conflict)]], noremap = false, desc = "Previous conflict" },
    ["n]n"] = { [[<Plug>(git-conflict-next-conflict)]], noremap = false, desc = "Next conflict" },
    ["n<leader>co"] = { [[<Plug>(git-conflict-ours)]], noremap = false, desc = "Choose ours" },
    ["n<leader>ct"] = { [[<Plug>(git-conflict-theirs)]], noremap = false, desc = "Choose theirs" },
  },
  -- ["markdown"] = {
  --   ["i<Tab>"] = {
  --     function()
  --       vim.api.nvim_input "<C-T>"
  --     end,
  --     { desc = "Increase Indent" },
  --   },
  --   ["i<S-Tab>"] = {
  --     function()
  --       vim.api.nvim_input "<C-D>"
  --     end,
  --     { desc = "Decrease Indent" },
  --   },
  -- },
}
