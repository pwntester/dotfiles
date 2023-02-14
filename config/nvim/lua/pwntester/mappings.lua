local mappings = {
  ["all"] = {

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

    -- terminal
    --["t<Esc>"] = { [[<C-\><C-n>]] },

    ["v*"] = {
      [[y/\V<C-R>=escape(@",'/\')<CR><CR>]],
      desc = "Search visual selection"
    },

    -- escape to normal mode
    ["ijk"] = {
      "<ESC>",
      desc = "Escape to normal mode"
    },
    ["tjk"] = {
      [[<C-\><C-n>]],
      desc = "Escape to normal mode"
    },

    -- shifting visual block should keep it selected
    ["v<"] = {
      "<gv",
      desc = "Shift visual block left"
    },
    ["v>"] = {
      ">gv|",
      desc = "Shift visual block right"
    },

    -- automatically jump to end of text you pasted
    --["vy"] = { "y`]" },
    ["vp"] = {
      "p`]",
      desc = "Paste and jump to end of text"
    },
    ["np"] = {
      "p`]",
      desc = "Paste and jump to end of text"
    },

    -- go up/down on visual line
    ["vj"] = {
      "gj",
      noremap = false,
      desc = "Go down on visual mode"
    },
    ["vk"] = {
      "gk",
      noremap = false,
      desc = "Go up on visual mode"
    },
    ["nj"] = {
      [[ (v:count? 'j' : 'gj') ]],
      expr = true,
      desc = "Go down on normal mode"
    },
    ["nk"] = {
      [[ (v:count? 'k' : 'gk') ]],
      expr = true,
      desc = "Go up on normal mode"
    },

    -- go to begining or end of line
    ["nB"] = {
      "^",
      desc = "Go to begining of line"
    },
    ["nE"] = {
      "$",
      desc = "Go to end of line"
    },

    -- move between windows

    -- ["n<C-h>"] = { [[<cmd>lua require('tmux').move_left()<CR>]] },
    -- ["n<C-j>"] = { [[<cmd>lua require('tmux').move_down()<CR>]] },
    -- ["n<C-k>"] = { [[<cmd>lua require('tmux').move_up()<CR>]] },
    -- ["n<C-l>"] = { [[<cmd>lua require('tmux').move_right()<CR>]] },
    ["n<c-k>"] = {
      ":wincmd k<CR>",
      desc = "Move to window above"
    },
    ["n<c-j>"] = {
      ":wincmd j<CR>",
      desc = "Move to window below"
    },
    ["n<c-h>"] = {
      ":wincmd h<CR>",
      desc = "Move to window at left"
    },
    ["n<c-l>"] = {
      ":wincmd l<CR>",
      desc = "Move to window at right"
    },
    ["t<c-k>"] = {
      "<C-\\><C-n><C-w>k",
      desc = "Move to window above"
    },
    ["t<c-j>"] = {
      "<C-\\><C-n><C-w>j",
      desc = "Move to window below"
    },
    ["t<c-h>"] = {
      "<C-\\><C-n><C-w>h",
      desc = "Move to window at left"
    },
    ["t<c-l>"] = {
      "<C-\\><C-n><C-w>l",
      desc = "Move to window at right"
    },
    -- wincmd K (switch to horizontal)
    -- wincmd H (switch to vertical)

    -- resize splits
    ["n<A-h>"] = {
      require("smart-splits").resize_left,
      desc = "Resize split left"
    },
    ["n<A-j>"] = {
      require("smart-splits").resize_down,
      desc = "Resize split down"
    },
    ["n<A-k>"] = {
      require("smart-splits").resize_up,
      desc = "Resize split up"
    },
    ["n<A-l>"] = {
      require("smart-splits").resize_right,
      desc = "Resize split right"
    },

    -- unimpaired like mappings
    ["n[b"] = {
      [[:bprevious<CR>]],
      desc = "Previous buffer"
    },
    ["n]b"] = {
      [[:bnext<CR>]],
      desc = "Next buffer"
    },
    ["n[q"] = {
      [[:cprevious<CR>]],
      desc = "Previous QF entry"
    },
    ["n]q"] = {
      [[:cnext<CR>]],
      desc = "Next QF entry"
    },
    ["n[l"] = {
      [[:lprevious<CR>]],
      desc = "Previous LOC entry"
    },
    ["n]l"] = {
      [[:lnext<CR>]],
      desc = "Next LOC entry"
    },
    ["n[t"] = {
      [[:tabprevious<CR>]],
      desc = "Previous tab"
    },
    ["n]t"] = {
      [[:tabnext<CR>]],
      desc = "Next tab"
    },

    -- paste keeping the default register
    ["v<leader>p"] = {
      '"_dP',
      desc = "Paste keeping the default register"
    },
    ["v<leader>x"] = {
      '"_d',
      desc = "Cut keeping the default register"
    },
    ["n<leader>x"] = {
      '"_x',
      desc = "Cut keeping the default register"
    },

    -- copy & paste to system clipboad
    ["v<leader>y"] = {
      '"*y',
      noremap = false,
      desc = "Copy to system clipboard"
    },

    -- quickly select text you pasted
    ["ngp"] = {
      [['`[' . strpart(getregtype(), 0, 1) . '`]']],
      expr = true,
      desc = "Select text pasted"
    },

    -- goto URL
    ["ngx"] = {
      g.openURL,
      desc = "Go to URL"
    },
    ["ngo"] = {
      "<Plug>(OctoOpenIssueAtCursor)",
      noremap = false,
      desc = "Open URL in Octo"
    },

    -- UFO
    ["nzR"] = {
      function() require('ufo').openAllFolds() end,
      desc = "Open all folds"
    },
    ["nzM"] = {
      function() require('ufo').closeAllFolds() end,
      desc = "Close all folds"
    },
    ["nzr"] = {
      function() require('ufo').openFoldsExceptKinds() end,
      desc = "Open fold"
    },
    ["nzm"] = {
      function() require('ufo').closeFoldsWith() end,
      desc = "Close fold"
    },
    ["nzP"] = {
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          -- choose one of coc.nvim and nvim lsp
          vim.fn.CocActionAsync('definitionHover') -- coc.nvim
          vim.lsp.buf.hover()
        end
      end,
      desc = "Preview fold"
    },

    -- COMMENT.NVIM
    ["ngc"] = {
      "<Plug>(comment_toggle_linewise_visual)",
      noremap = false,
      desc = "Coment linewise"
    },
    ["ngb"] = {
      "<Plug>(comment_toggle_blockwise)",
      noremap = false,
      desc = "Coment blockwise"
    },

    -- TOGGLETERM
    ["n<C-\\>"] = {
      "<Plug>(ToggleTerm)",
      noremap = false,
      desc = "Toggle terminal"
    },
    ["n<leader>gg"] = {
      "<Plug>(LazyGit)",
      noremap = false,
      desc = "Lazygit"
    },

    -- TELESCOPE
    -- ["n<leader>n"] = {
    --   require('github-notifications.menu').notifications,
    --   desc = "GitHub notifications",
    -- },
    ["n<leader>f"] = {
      function() require('telescope.builtin').find_files() end,
      desc = "Find files",
    },
    ["n<leader>l"] = {
      function() require 'telescope.builtin'.live_grep() end,
      desc = "Live grep",
    },
    ["n<leader>r"] = {
      function() require 'telescope.builtin'.reloader() end,
      desc = "Reload module",
    },
    ["n<leader>o"] = {
      function() require 'telescope.builtin'.buffers() end,
      desc = "Open buffers",
    },
    ["n<leader>s"] = {
      function() require 'telescope.builtin'.grep_string({ word_match = '-w' }) end,
      desc = "Grep string",
    },
    ["n<leader>gc"] = {
      function() require 'telescope.builtin'.git_commits() end,
      desc = "Git commits",
    },
    ["n<leader>gf"] = {
      function() require 'telescope.builtin'.git_files() end,
      desc = "Git files",
    },
    ["n<leader>gb"] = {
      function() require 'telescope.builtin'.git_branches() end,
      desc = "Git branches",
    },
    ["n<leader>bs"] = {
      function() require 'telescope.builtin'.current_buffer_fuzzy_find() end,
      desc = "Current buffer fuzzy find",
    },
    ["n<leader>p"] = {
      function() require 'telescope'.extensions.projects.projects() end,
      desc = "Projects",
    },
    ["n<leader>m"] = {
      function() require 'telescope'.extensions.frecency.frecency() end,
      desc = "Most Recently Used",
    },

    -- GITSIGNS
    ["n[h"] = {
      "<Plug>(GitGutterPrevHunk)",
      noremap = false,
      desc = "Previous hunk"
    },
    ["n]h"] = {
      "<Plug>(GitGutterNextHunk)",
      noremap = false,
      desc = "Next Hunk"
    },

    -- NEO-TREE
    ["nge"] = {
      [[:Neotree action=show source=filesystem position=left toggle=true reveal=true reveal_force_cwd=true<CR>]],
      desc = "NeoTree files"
    },
    ["n<C-o>"] = {
      [[:Neotree action=show source=buffers position=right toggle=true<CR>]],
      desc = "NeoTree buffers"
    },

    -- DIAL
    ["n<C-a>"] = {
      [[<Plug>(dial-increment)]],
      desc = "Increment"
    },
    ["n<C-x>"] = {
      [[<Plug>(dial-decrement)]],
      desc = "Decrement"
    },
    ["v<C-a>"] = {
      [[<Plug>(dial-increment)]],
      desc = "Increment"
    },
    ["v<C-x>"] = {
      [[<Plug>(dial-decrement)]],
      desc = "Decrement"
    },

    -- TROUBLE
    ['n<leader>xx'] = {
      [[<cmd>LspTroubleToggle<cr>]],
      desc = "Toggle LSP trouble"
    },
    ['n<leader>xw'] = {
      [[<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>]],
      desc = "Toggle LSP workspace diagnostics"
    },
    ['n<leader>xd'] = {
      [[<cmd>LspTroubleToggle lsp_document_diagnostics<cr>]],
      desc = "Toggle LSP document diagnostics"
    },
    ['n<leader>xl'] = {
      [[<cmd>LspTroubleToggle loclist<cr>]],
      desc = "Toggle LSP loclist"
    },
    ['n<leader>xq'] = {
      [[<cmd>LspTroubleToggle quickfix<cr>]],
      desc = "Toggle LSP quickfix"
    },
    ['n<leader>xr'] = {
      [[<cmd>LspTrouble lsp_references<cr>]],
      desc = "LSP references"
    },

    -- GOTO-PREVIEW
    ["ngP"] = {
      require('goto-preview').goto_preview_definition,
      desc = "Goto preview"
    },

    -- COPILOT
    --["i<C-l>"] = { [[copilot#Accept("<CR>")]], silent = true, script = true, expr = true, desc = "Accept Copilot suggestion" },
    --["i<Right>"] = { [[copilot#Accept("<CR>")]], silent = true, script = true, expr = true, desc = "Accept Copilot suggestion" },

    -- ZK
    ["n<leader>zt"] = {
      function() require("pwntester.zk").dailyNote() end,
      desc = "Open journal note"
    },
    ["n<leader>zn"] = {
      "<Cmd>ZkNew { title = vim.fn.input('Title: '), dir = 'areas/inbox' }<CR>",
      desc = "Create a new note after asking for its title"
    },
    ["n<leader>zo"] = {
      "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
      desc = "Open notes"
    },
    ["n<leader>zf"] = {
      "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>",
      desc = "Search for the notes matching a given query"
    },
    ["v<leader>zf"] = {
      ":'<,'>ZkMatch<CR>",
      desc = "Search for the notes matching the current visual selection"
    },

    -- LUASNIP
    ["i<C-j>"] = {
      function()
        local ls = require "luasnip"
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      silent = true,
      desc = "Expand or jump"
    },
    ["s<C-j>"] = {
      function()
        local ls = require "luasnip"
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      silent = true,
      desc = "Expand or jump"
    },
    ["i<C-k>"] = {
      function()
        local ls = require "luasnip"
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      silent = true,
      desc = "Jump back"
    },
    ["s<C-k>"] = {
      function()
        local ls = require "luasnip"
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      silent = true,
      desc = "Jump back"
    },
    ["i<a-j>"] = {
      function()
        local ls = require "luasnip"
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end,
      silent = true,
      desc = "Change choice"
    },
    ["s<a-j>"] = {
      function()
        local ls = require "luasnip"
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end,
      silent = true,
      desc = "Change choice"
    },
    ["i<a-k>"] = {
      function()
        local ls = require "luasnip"
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      silent = true,
      desc = "Change choice"
    },
    ["s<a-k>"] = {
      function()
        local ls = require "luasnip"
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      silent = true,
      desc = "Change choice"
    },

    -- NVIM-HLSLENS
    -- ["nn"] = {
    --   [[<CMD>execute('normal! ' . v:count1 . 'n')<CR><CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Next match"
    -- },
    -- ["nN"] = {
    --   [[<CMD>execute('normal! ' . v:count1 . 'N')<CR><CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Previous match"
    -- },
    -- ["n*"] = {
    --   [[*<CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Next match"
    -- },
    -- ["n#"] = {
    --   [[#<CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Previous match"
    -- },
    -- ["ng*"] = {
    --   [[g*<CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Next match"
    -- },
    -- ["ng#"] = {
    --   [[g#<CMD>lua require('hlslens').start()<CR>]],
    --   silent = true,
    --   desc = "Previous match"
    -- },

    -- CODEQL
    -- ["n<leader>c"] = {
    --   [[<Plug>(CodeQLGrepSource)]],
    --   noremap = false,
    --   desc = "Grep CodeQL archive"
    -- },
  },
  ["markdown"] = {
    ["i<C-u>"] = {
      require("pwntester.markdown").pasteLink,
      desc = "Paste link"
    },
    ["i<C-b>"] = {
      require("pwntester.markdown").insertCheckbox,
      desc = "Insert checkbox"
    },
    ["i<CR>"] = {
      require("pwntester.markdown").markdownEnter,
      desc = "Markdown enter"
    },
    ["no"] = {
      require("pwntester.markdown").markdownO,
      desc = "Markdown o"
    },
    ["nO"] = {
      require("pwntester.markdown").markdownShiftO,
      desc = "Markdown O"
    },
    ["n<leader>i"] = {
      require("pwntester.markdown").toggleEntries,
      desc = "Toggle entries"
    },
    ["v<leader>i"] = {
      [[:'<,'>lua require("pwntester.markdown").toggleEntries()<CR>]],
      desc = "Toggle entries"
    },
  },
  ["zk"] = {
    ["n<CR>"] = {
      function() vim.lsp.buf.definition() end,
      desc = "Open the link under the caret"
    },
    ["n<leader>zb"] = {
      "<Cmd>ZkBacklinks<CR>",
      desc = "Open notes linking to the current buffer"
    },
    ["n<leader>zl"] = {
      "<Cmd>ZkLinks<CR>",
      desc = "Open notes linked by the current buffer"
    },
    ["nK"] = {
      function() vim.lsp.buf.hover() end,
      desc = "Preview a linked note"
    },
    ["v<leader>za"] = {
      ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
      desc = "Open the code actions for a visual selection"
    },
    ["n<leader>zn"] = {
      "<Cmd>ZkNew { dir = 'areas/inbox', title = vim.fn.input('Title: ') }<CR>",
      desc = "Create new note"
    },
    ["v<leader>znt"] = {
      ":'<,'>ZkNewFromTitleSelection { dir = 'areas/inbox' }<CR>",
      desc = "Create a new note using the current selection for title."
    },
    ["v<leader>znc"] = {
      ":'<,'>ZkNewFromContentSelection { dir = 'areas/inbox', title = vim.fn.input('Title: ') }<CR>",
      desc = "Create a new note using the current selection for note content and asking for its title"
    },
    ["i<C-n>"] = {
      function() require("pwntester.zk").templateNote() end,
      desc = "Create new templated note"
    },
  },
  ["lsp"] = {
    ["ngdc"] = {
      vim.lsp.buf.declaration,
      desc = "Goto declaration"
    },
    ["ngi"] = {
      vim.lsp.buf.implementation,
      desc = "Goto implementation"
    },
    ["ngtt"] = {
      vim.lsp.buf.type_definition,
      desc = "Goto type definition"
    },
    --[[ ["ng="] = { ]]
    --[[   vim.lsp.buf.formatting, ]]
    --[[   desc = "Format document" ]]
    --[[ }, ]]
    ["ngic"] = {
      vim.lsp.buf.incoming_calls,
      desc = "Incoming calls"
    },
    ["ngoc"] = {
      vim.lsp.buf.outgoing_calls,
      desc = "Outcoming calls"
    },
    ["ngK"] = {
      vim.lsp.buf.hover,
      desc = "Hover"
    },
    ["ngD"] = {
      function() vim.diagnostic.open_float(0, { scope = "line", border = "single" }) end,
      desc = "Show diagnostics"
    },
    ["ngd"] = {
      function() require "telescope.builtin".lsp_definitions() end,
      desc = "Goto definition"
    },
    ["ngr"] = {
      function() require "telescope.builtin".lsp_references() end,
      desc = "Goto references"
    },

    -- RENAMER
    ["i<F2>"] = {
      function() require("renamer").rename() end,
      desc = "Rename"
    },
    ["n<leader>rn"] = {
      function() require("renamer").rename() end,
      desc = "Rename"
    },
    ["v<leader>rn"] = {
      function() require("renamer").rename() end,
      desc = "Rename"
    },

    -- ['ngP']     = { [[<Plug>(LspPreviewDefinition)]], noremap = false};
    -- ["ngf"] = { [[<Plug>(LspFinder)]], noremap = false },
    -- ['i<c-s>']  = { [[<Plug>(LspShowSignatureHelp)]], noremap = false};
    -- ["n]e"] = { [[<Plug>(LspNextDiagnostic)]], noremap = false },
    -- ["n[e"] = { [[<Plug>(LspPrevDiagnostic)]], noremap = false },
    -- ["n<A-CR>"] = { [[<Plug>(LspCodeActions)]], noremap = false },
    -- ["v<A-CR>"] = { [[<Plug>(LspRangeCodeActions)]], noremap = false },
  },
  ["lsp_jdt"] = {
    ["n<A-o>"] = { function() require 'jdtls'.organize_imports() end },
    ["ncrv"] = { function() require 'jdtls'.extract_variable() end },
    ["vcrv"] = { function() require 'jdtls'.extract_variable() end },
    ["ncrc"] = { function() require 'jdtls'.extract_constant() end },
    ["vcrc"] = { function() require 'jdtls'.extract_constant() end },
    ["vcrm"] = { function() require 'jdtls'.extract_method() end },
  },
  ["treesitter"] = {
    ["n<CR>"] = {
      [[<Plug>(TsSelInit)]],
      noremap = false,
      desc = "Select context incrementally"
    },
    ["x<CR>"] = {
      [[<Plug>(TsSelScopeIncr)]],
      noremap = false,
      desc = "Select context incrementally"
    },
    ["x<Tab>"] = {
      [[<Plug>(TsSelNodeIncr)]],
      noremap = false,
      desc = "Select node incrementally"
    },
    ["x<S-Tab>"] = {
      [[<Plug>(TsSelNodeDecr)]],
      noremap = false,
      desc = "Select node incrementally"
    },
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
  ["gitconflict"] = {
    ["n[n"] = { [[<Plug>(git-conflict-prev-conflict)]], noremap = false, desc = "Previous conflict" },
    ["n]n"] = { [[<Plug>(git-conflict-next-conflict)]], noremap = false, desc = "Next conflict" },
    ["n<leader>co"] = { [[<Plug>(git-conflict-ours)]], noremap = false, desc = "Choose ours" },
    ["n<leader>ct"] = { [[<Plug>(git-conflict-theirs)]], noremap = false, desc = "Choose theirs" },
  }
}

return mappings
