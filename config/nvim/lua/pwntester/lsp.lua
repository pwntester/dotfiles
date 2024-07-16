local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
local g = require "pwntester.globals"
local vim = vim

local servers = {
  "pyright",
  "bashls",
  "lua_ls",
  "tsserver",
  "gopls",
  "codeqlls",
  "yamlls",
  "jsonls",
  "dockerls",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function get_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

local function on_attach_callback(client, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Configure key mappings
  g.map(require("pwntester.mappings").lsp, { silent = false }, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr")
end

local function setup()
  -- configure servers
  local server_opts = {
    ["sumneko_lua"] = {
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
        --nvim_lsp.gopls.default_config.root_dir(fname)
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
      -- settings = {
      --   search_path = vim.split(require("codeql.util").get_additional_packs(), ":"),
      -- },
    },
    ["pyright"] = {},
  }

  -- setup servers
  for _, lsp in pairs(servers) do
    local opts = server_opts[lsp] or {}
    opts.capabilities = opts.capabilities or capabilities
    opts.on_attach = opts.on_attach or on_attach_callback
    opts.flags = opts.flags or { debounce_text_changes = 150 }
    -- opts.handlers = {
    --   ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --     signs = true,
    --     underline = true,
    --     update_in_insert = false,
    --     virtual_text = false,
    --     -- {
    --     --   spacing = 4,
    --     --   prefix = "»",
    --     -- },
    --   }),
    -- }
    lspconfig[lsp].setup(opts)
  end

  -- TODO: dont seem to be working, so Im using the `handlers` property in the LSP setup
  vim.diagnostic.config {
    float = { border = "rounded" },
    underline = true,
    update_in_insert = false,
    -- virtual_lines = {
    --     highlight_whole_line = false,
    --     -- only_current_line = true,
    -- },
    virtual_text = false,
    -- virtual_text = {
    -- 	prefix = function(diagnostic)
    -- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
    -- 			return U.signs.diagnostic.error
    -- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
    -- 			return U.signs.diagnostic.warning
    -- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
    -- 			return U.signs.diagnostic.info
    -- 		else
    -- 			return U.signs.diagnostic.hint
    -- 		end
    -- 	end,
    -- },
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
        -- [vim.diagnostic.severity.OK] = icons.signs.diagnostic.ok,
      },
    },
    severity_sort = true,
  }
end

return {
  setup = setup,
  servers = servers,
  get_clients = get_clients,
}
