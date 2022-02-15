local vim = vim
local api = vim.api
local nvim_lsp = require "lspconfig"
local window = require "pwntester.window"
local util = require "lspconfig/util"

local clients = {}

local function register_buffer(bufnr, client_id)
  if not clients[bufnr] then
    clients[bufnr] = { client_id }
  else
    table.insert(clients[bufnr], client_id)
  end
end

local function on_attach_callback(client, bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()

  -- register client/buffer relation
  register_buffer(bufnr, client.id)

  -- mappings
  g.map(require("pwntester.mappings").lsp, { silent = false, noremap = true }, bufnr)

  -- Extensions
  --require("illuminate").on_attach(client)
end

local function setup()
  -- diagnostics signs
  vim.fn.sign_define("LspDiagnosticsSignError", {
    text = "",
    texthl = "LspDiagnosticsSignError",
  })
  vim.fn.sign_define("LspDiagnosticsSignWarning", {
    text = "",
    texthl = "LspDiagnosticsSignWarning",
  })
  vim.fn.sign_define("LspDiagnosticsSignInformation", {
    text = "i",
    texthl = "LspDiagnosticsSignInformation",
  })
  vim.fn.sign_define("LspDiagnosticsSignHint", {
    text = "h",
    texthl = "LspDiagnosticsSignHint",
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    update_in_insert = false,
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = "»",
    },
  })

  -- custom handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = window.window_border_chars,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = window.window_border_chars,
  })
  -- vim.lsp.handlers['textDocument/references'] = function(_, _, result)
  --   if not result then return end
  --   util.set_qflist(util.locations_to_items(result))
  --   api.nvim_command("botright copen")
  --   api.nvim_command("wincmd p")
  -- end

  -- language servers

  --- Lua
  nvim_lsp.sumneko_lua.setup {
    cmd = {
      "/usr/local/bin/lua-language-server",
    },
    on_attach = on_attach_callback,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
      Lua = {
        completion = { keywordSnippet = "Disable" },
        diagnostics = {
          enable = true,
          globals = {
            "vim",
            "describe",
            "it",
            "before_each",
            "after_each",
          },
        },
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
        },
      },
    },
  }

  --- JavaScript
  nvim_lsp.tsserver.setup {
    on_attach = on_attach_callback,
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd(),
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
  }

  --- Go
  nvim_lsp.gopls.setup {
    on_attach = on_attach_callback,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = function(fname)
      if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
        return
      end
      nvim_lsp.gopls.default_config.root_dir(fname)
    end,
  }

  --- Ruby
  nvim_lsp.solargraph.setup {
    on_attach = on_attach_callback,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
  }

  --- .NET
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/Users/pwntester/repos/omnisharp-osx/run"
  nvim_lsp.omnisharp.setup {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach_callback,
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = function(fname)
      if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
        return
      end
      nvim_lsp.omnisharp.default_config.root_dir(fname)
    end,
  }

  --- CodeQL
  nvim_lsp.codeqlls.setup {
    on_attach = on_attach_callback,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = function(fname)
      if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
        return
      end
      local root_pattern = util.root_pattern "qlpack.yml"
      return root_pattern(fname) or util.path.dirname(fname)
    end,
    settings = {
      search_path = vim.g.codeql_search_path,
    },
  }

  --- ZK
  nvim_lsp.zk.setup {
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    root_dir = function()
      return vim.loop.cwd()
    end,
    --root_dir = function() return vim.g.zk_notebook end;
    on_attach = function(client, bufnr)
      on_attach_callback(client, bufnr)
      g.map(require("pwntester.mappings").zk, { silent = true, noremap = true }, bufnr)
    end,
  }

  --- Fortify Language Server
  -- if not configs.fortify_lsp then
  --   configs.fortify_lsp = {
  --     default_config = {
  --       cmd = { "fls" },
  --       filetypes = { "fortifyrulepack" },
  --       root_dir = function(fname)
  --         return nvim_lsp.util.path.dirname(fname)
  --       end,
  --     },
  --   }
  -- end
  -- nvim_lsp.fortify_lsp.setup {
  --   on_attach = on_attach_callback,
  -- }
end

return {
  setup = setup,
  clients = clients,
  on_attach_callback = on_attach_callback,
}
