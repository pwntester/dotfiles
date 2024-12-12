return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local lspconfig = require "lspconfig"
    local util = require "lspconfig.util"
    local g = require "pwntester.globals"
    local servers = require("pwntester.lsp").servers
    local server_opts = {
      ["codeqlls"] = {
        root_dir = function(fname)
          if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
            return
          end
          local root_pattern = util.root_pattern "qlpack.yml"
          return root_pattern(fname) or util.path.dirname(fname)
        end,
      },
    }
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- capabilities.workspace = {
    --   didChangeWatchedFiles = {
    --     dynamicRegistration = true,
    --   },
    -- }

    local on_attach_callback = function(client, bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()

      -- Configure key mappings
      g.map(require("pwntester.mappings").lsp, { silent = false }, bufnr)

      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end

      -- Use LSP as the handler for formatexpr.
      vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr")

      if client.name == "markdown_oxide" then
        vim.api.nvim_create_user_command("Daily", function(args)
          local input = args.args

          vim.lsp.buf.execute_command { command = "jump", arguments = { input } }
        end, { desc = "Open daily note", nargs = "*" })
      end
    end

    for server, _ in pairs(servers) do
      local opts = server_opts[server] or {}
      opts.capabilities = opts.capabilities or {}
      opts.on_attach = opts.on_attach or on_attach_callback
      opts.flags = opts.flags or { debounce_text_changes = 150 }
      lspconfig[server].setup(opts)
    end

    -- configure diagnostics
    vim.diagnostic.config {
      float = { border = "rounded" },
      underline = true,
      update_in_insert = false,
      -- keep it to false for tiny-inline-diagnostic to work
      virtual_text = false,
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
      severity_sort = true,
    }
  end,
}
