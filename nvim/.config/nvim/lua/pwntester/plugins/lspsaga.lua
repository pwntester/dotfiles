return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    local ui = {
      border = 'rounded',
      winblend = 0,
      title = false,
      diagnostic = '  ',
    }

    local lightbulb = {
      enable = false,
    }

    local definition = {
      edit = '<C-e>',
      vsplit = '<C-v>',
      split = '<C-h>',
      quit = '<C-q>',
    }

    local winbar = {
      enable = true,
      folder_level = 1,
      show_file = true,
      separator = '  ',
    }

    local diagnostic = {
      show_code_action = true,
      on_insert = false,
      show_source = false,
      border_follow = false,
      text_hl_follow = true,
      extend_relatedInformation = true,
    }

    local hover = {
      max_width = 0.5,
    }
    require('lspsaga').setup {
      lightbulb = lightbulb,
      ui = ui,
      definition = definition,
      symbol_in_winbar = winbar,
      diagnostic = diagnostic,
      hover = hover,
    }
  end,

  keys = {
    {
      '<leader>rn',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga rename'
      end,
    },
    {
      ']d',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga diagnostic_jump_next'
      end,
    },
    {
      '[d',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga diagnostic_jump_prev'
      end,
    },
    {
      '<leader>dl',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga show_line_diagnostics ++normal'
      end,
    },
    {
      '<leader>db',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga show_buf_diagnostics ++normal'
      end,
    },
    {
      '<leader>dw',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga show_workspace_diagnostics ++normal'
      end,
    },
    {
      '<leader>lo',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga outline'
      end,
    },
    {
      'gr',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga finder ref'
      end,
    },
    {
      'gD',
      mode = { 'n' },
      function()
        vim.cmd 'Lspsaga finder ref+def+imp'
      end,
    },
    {
      'gd',
      mode = { 'n' },
      function()
        -- Jump to definition if there is only one, otherwise open Lspsaga finder
        local clients = vim.lsp.get_clients()
        local params = vim.lsp.util.make_position_params(nil, clients[1].offset_encoding or 'utf-16')

        vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result)
          if err then
            print('Error: ' .. err.message)
            return
          end

          if not result or vim.tbl_isempty(result) then
            return
          end

          local count = 0
          if vim.islist(result) then
            count = #result
          elseif type(result) == 'table' then
            count = 1
          end

          if count == 1 then
            -- Jump directly to the single definition
            vim.lsp.buf.definition()
          else
            -- Open Lspsaga finder for multiple definitions
            vim.cmd 'Lspsaga finder def'
          end
        end)
      end,
    },
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
