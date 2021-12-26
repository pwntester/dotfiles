local vim = vim
local api = vim.api
local nvim_lsp = require "lspconfig"
local window = require "pwntester.window"
local util = require "lspconfig/util"
local jdtls = require "jdtls"

local clients = {}

local function on_init_callback(client)
  -- require('me.lsp.ext').setup()
  -- https://github.com/mfussenegger/dotfiles/blob/d04a4f1d7e338f946016bfc4f71d5ca98250da5e/vim/.config/nvim/lua/me/lsp/ext.lua
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local function register_buffer(bufnr, client_id)
  if not clients[bufnr] then
    clients[bufnr] = { client_id }
  else
    table.insert(clients[bufnr], client_id)
  end
end

local function on_attach_callback(client, bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  --vim.notify("Attaching LSP client "..client.id.." to buffer "..bufnr)

  -- register client/buffer relation
  register_buffer(bufnr, client.id)

  -- mappings
  g.map(require("pwntester.mappings").lsp, { silent = false, noremap = true }, bufnr)

  -- Extensions
  --require("illuminate").on_attach(client)
  --require 'aerial'.on_attach(client)
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
      "/Users/pwntester/repos/lua-language-server/bin/macOS/lua-language-server",
      "-E",
      "/Users/pwntester/repos/lua-language-server/main.lua",
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

local function start_jdt()
  local bufname = vim.fn.bufname()
  if vim.startswith(bufname, "codeql:") or vim.startswith(bufname, "octo:") then
    return
  end
  local root_markers = { "gradlew", "mwnw", ".git" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  local home = os.getenv "HOME"
  local workspace_folder = home .. "/jdt_ws/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  local jdt_capabilities = vim.lsp.protocol.make_client_capabilities()
  jdt_capabilities.workspace.configuration = true
  jdt_capabilities.textDocument.completion.completionItem.snippetSupport = true

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local config = {
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
      server_side_fuzzy_completion = true,
    },
    capabilities = jdt_capabilities,
    init_options = {
      extendedClientCapabilities = extendedClientCapabilities,
    },
    on_init = on_init_callback,
    filetypes = { "java" },
    cmd = { "/Users/pwntester/bin/jdtls", workspace_folder },
    on_attach = function(client, bufnr)
      on_attach_callback(client, bufnr)
      jdtls.setup.add_commands()

      -- mappings
      local map = function(type, key, value)
        api.nvim_buf_set_keymap(bufnr, type, key, value, { noremap = true, silent = true })
      end

      -- TODO: Can we make these look like the saga ones?
      map("n", "<Plug>(LspCodeActions)", '<cmd>lua require("jdtls").code_action()<CR>')
      map("v", "<Plug>(LspRangeCodeActions)", ':<C-U>lua lua require("jdtls").code_action(true)<CR>')
    end,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
        },
        configuration = {
          runtimes = {
            -- {
            --   name = "JavaSE-8",
            --   path = "/Users/pwntester/.sdkman/candidates/java/8.0.242.hs-adpt/",
            -- },
            {
              name = "JavaSE-11",
              path = "/Users/pwntester/.sdkman/candidates/java/11.0.6.hs-adpt/",
            },
          },
        },
      },
    },
  }
  jdtls.start_or_attach(config)
end

local function setup_jdt()
  vim.cmd [[augroup lsp]]
  vim.cmd [[au!]]
  vim.cmd [[au FileType java lua require('pwntester.lsp').start_jdt()]]
  vim.cmd [[augroup end]]

  local finders = require "telescope.finders"
  local sorters = require "telescope.sorters"
  local actions = require "telescope.actions"
  local pickers = require "telescope.pickers"
  require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
    local dropdown_opts = require("telescope.themes").get_dropdown {
      layout_config = {
        width = 0.4,
        height = 15,
      },
      prompt_title = "",
      previewer = false,
      borderchars = {
        prompt = window.window_border_chars_telescope_prompt,
        results = window.window_border_chars_telescope_results,
        preview = window.window_border_chars_telescope_preview,
      },
    }
    pickers.new(dropdown_opts, {
      prompt_title = prompt,
      finder = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = label_fn(entry),
            ordinal = label_fn(entry),
          }
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = actions.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)

          cb(selection.value)
        end)

        return true
      end,
    }):find()
  end
end

return {
  setup = setup,
  start_jdt = start_jdt,
  setup_jdt = setup_jdt,
  clients = clients,
  on_attach_callback = on_attach_callback,
}
