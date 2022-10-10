local nvim_lsp = require "lspconfig"
local window = require "pwntester.window"
local util = require "lspconfig.util"
--local efm = require "pwntester.plugins.efm"

local servers = {
  "pyright",
  "bashls",
  "sumneko_lua",
  "tsserver",
  "gopls",
  "solargraph",
  "codeqlls",
  "yamlls",
  "jsonls",
  "dockerls",
  --"zk",
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function on_attach_callback(client, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Configure Extensions
  require("lsp-format").on_attach(client)
  require("lsp_spinner").on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  -- Configure formatting
  require("pwntester.plugins.null-ls.formatters").setup(client, bufnr)

  -- Configure key mappings
  g.map(require("pwntester.mappings").lsp, { silent = false }, bufnr)
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

  -- configure servers
  local server_opts = {
    ["sumneko_lua"] = {
      --[[ on_attach = function(client, bufnr) ]]
      --[[   on_attach_callback(client, bufnr) ]]
      --[[   -- Disable `sumneko`'s formatting capability so that null-ls is registered as the only compatible formatter. ]]
      --[[   client.server_capabilities.document_formatting = false ]]
      --[[   client.server_capabilities.document_range_formatting = false ]]
      --[[ end, ]]
      settings = {
        Lua = {
          completion = { keywordSnippet = "Disable" },
          diagnostics = {
            enable = true,
            globals = {
              -- neovim
              "vim",
              -- busted
              "describe",
              "it",
              "before_each",
              "after_each",
              -- packer
              "use",
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
    },
    ["tsserver"] = {
      root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd(),
    },
    ["gopls"] = {
      root_dir = function(fname)
        if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
          return
        end
        nvim_lsp.gopls.default_config.root_dir(fname)
      end,
    },
    ["codeqlls"] = {
      root_dir = function(fname)
        if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
          return
        end
        local root_pattern = util.root_pattern "qlpack.yml"
        return root_pattern(fname) or util.path.dirname(fname)
      end,
      settings = {
        search_path = { "/Users/pwntester/codeql-home/codeql" }
      }
    },
    --[[ ["zk"] = { ]]
    --[[   root_dir = function() ]]
    --[[     return vim.loop.cwd() ]]
    --[[   end, ]]
    --[[   on_attach = function(client, bufnr) ]]
    --[[     on_attach_callback(client, bufnr) ]]
    --[[     g.map(require("pwntester.mappings").zk, { silent = true }, bufnr) ]]
    --[[   end, ]]
    --[[ }, ]]
    ["null-ls"] = {},
    ["pyright"] = {},
    --[[ ["efm"] = { ]]
    --[[   init_options = { documentFormatting = true, codeAction = true }, ]]
    --[[   filetypes = { "lua", "python", "yaml", "json", "typescript", "javascript" }, ]]
    --[[   settings = { ]]
    --[[     log_level = 1, ]]
    --[[     log_file = "/tmp/efm.log", ]]
    --[[     rootMarkers = { ".git/" }, ]]
    --[[     languages = { ]]
    --[[       lua = { efm.stylua }, ]]
    --[[       python = { efm.black, efm.isort, efm.flake8, efm.mypy }, ]]
    --[[       yaml = { efm.prettier }, ]]
    --[[       json = { efm.prettier }, ]]
    --[[       typescript = { efm.prettier, efm.eslint }, ]]
    --[[       javascript = { efm.prettier, efm.eslint }, ]]
    --[[       sh = { efm.shellcheck, efm.shfmt }, ]]
    --[[       go = { efm.staticcheck, efm.goimports, efm.govet }, ]]
    --[[       ["="] = { efm.misspell }, ]]
    --[[     }, ]]
    --[[   }, ]]
    --[[ }, ]]
  }

  -- setup servers
  for _, lsp in pairs(servers) do
    local opts = server_opts[lsp] or {}
    opts.capabilities = opts.capabilities or capabilities
    opts.on_attach = opts.on_attach or on_attach_callback
    opts.flags = opts.flags or { debounce_text_changes = 150 }
    require("lspconfig")[lsp].setup(opts)
  end

  -- custom handlers
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    update_in_insert = false,
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = "»",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = window.window_border_chars,
  })

  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = window.window_border_chars,
  -- })
  -- vim.lsp.handlers['textDocument/references'] = function(_, _, result)
  --   if not result then return end
  --   util.set_qflist(util.locations_to_items(result))
  --   api.nvim_command("botright copen")
  --   api.nvim_command("wincmd p")
  -- end

  -- .NET
  -- local pid = vim.fn.getpid()
  -- local omnisharp_bin = "/Users/pwntester/repos/omnisharp-osx/run"
  -- nvim_lsp.omnisharp.setup {
  --   cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
  --   capabilities = capabilities,
  --   on_attach = on_attach_callback,
  --   flags = {
  --     debounce_text_changes = 150,
  --   },
  --   root_dir = function(fname)
  --     if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
  --       return
  --     end
  --     nvim_lsp.omnisharp.default_config.root_dir(fname)
  --   end,
  -- }
  -- Fortify Language Server
  -- if not nvim_lsp.fortify_lsp then
  --   nvim_lsp.fortify_lsp = {
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
  on_attach_callback = on_attach_callback,
  servers = servers,
}
