local vim = vim
local api = vim.api
local nvim_lsp = require "lspconfig"
local window = require "pwntester.window"
local util = require "lspconfig/util"
local lsp_installer = require "nvim-lsp-installer"

local clients = {}

local servers = {
  "bashls",
  "pyright",
  "sumneko_lua",
  "tsserver",
  "gopls",
  "solargraph",
  "codeqlls",
  "zk",
  "yamlls",
  "jsonls",
  "dockerls",
}

local function register_buffer(bufnr, client_id)
  if not clients[bufnr] then
    clients[bufnr] = { client_id }
  else
    table.insert(clients[bufnr], client_id)
  end
end

local function on_attach_callback(client, bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()

  -- extensions
  require("lsp-format").on_attach(client)
  require("lsp_signature").on_attach {
    hint_enable = false,
    hi_parameter = "QuickFixLine",
    handler_opts = {
      border = vim.g.floating_window_border,
    },
  }

  -- register client/buffer relation
  register_buffer(bufnr, client.id)

  -- mappings
  g.map(require("pwntester.mappings").lsp, { silent = false, noremap = true }, bufnr)
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

  -- install servers
  for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end

  -- configure servers
  local server_opts = {
    ["sumneko_lua"] = function(opts)
      opts.settings = {
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
      }
    end,
    ["tsserver"] = function(opts)
      opts.root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd()
    end,
    ["gopls"] = function(opts)
      opts.root_dir = function(fname)
        if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
          return
        end
        nvim_lsp.gopls.default_config.root_dir(fname)
      end
    end,
    ["codeqlls"] = function(opts)
      opts.root_dir = function(fname)
        if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") or vim.startswith(fname, "docker:") then
          return
        end
        local root_pattern = util.root_pattern "qlpack.yml"
        return root_pattern(fname) or util.path.dirname(fname)
      end
      opts.settings = {
        search_path = require("codeql.config").get_config().search_path,
      }
    end,
    ["zk"] = function(opts)
      opts.on_attach = function(client, bufnr)
        on_attach_callback(client, bufnr)
        g.map(require("pwntester.mappings").zk, { silent = true, noremap = true }, bufnr)
      end
    end,
    ["efm"] = function(opts)
      local stylua = require "pwntester.plugins.efm.stylua"
      local staticcheck = require "pwntester.plugins.efm.staticcheck"
      local go_vet = require "pwntester.plugins.efm.go_vet"
      local goimports = require "pwntester.plugins.efm.goimports"
      local black = require "pwntester.plugins.efm.black"
      local isort = require "pwntester.plugins.efm.isort"
      local flake8 = require "pwntester.plugins.efm.flake8"
      local mypy = require "pwntester.plugins.efm.mypy"
      local prettier = require "pwntester.plugins.efm.prettier"
      local eslint = require "pwntester.plugins.efm.eslint"
      local shellcheck = require "pwntester.plugins.efm.shellcheck"
      local shfmt = require "pwntester.plugins.efm.shfmt"
      local misspell = require "pwntester.plugins.efm.misspell"
      opts.init_options = { documentFormatting = true, codeAction = true }
      opts.filetypes = { "lua", "python", "yaml", "json", "typescript", "javascript", "markdown" }
      opts.settings = {
        log_level = 1,
        log_file = "/tmp/efm.log",
        rootMarkers = { ".git/" },
        languages = {
          lua = { stylua },
          python = { black, isort, flake8, mypy },
          yaml = { prettier },
          json = { prettier },
          markdown = { prettier },
          typescript = { prettier, eslint },
          javascript = { prettier, eslint },
          sh = { shellcheck, shfmt },
          go = { staticcheck, goimports, go_vet },
          ["="] = { misspell },
        },
      }
    end,
  }

  -- setup servers
  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach_callback,
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      flags = {
        debounce_text_changes = 150,
      },
    }

    if server_opts[server.name] then
      server_opts[server.name](opts)
    end

    server:setup(opts)
  end)

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
  clients = clients,
  on_attach_callback = on_attach_callback,
}
