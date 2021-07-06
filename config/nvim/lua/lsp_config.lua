local vim = vim
local api = vim.api
local nvim_lsp = require'lspconfig'
local window = require'window'
local configs = require'lspconfig/configs'
local util = require 'lspconfig/util'
local jdtls = require 'jdtls'

local clients = {}

local function on_init_callback(client)
  --TODO:
  -- require('me.lsp.ext').setup()
  -- https://github.com/mfussenegger/dotfiles/blob/d04a4f1d7e338f946016bfc4f71d5ca98250da5e/vim/.config/nvim/lua/me/lsp/ext.lua
  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end
end

local function register_buffer(bufnr, client_id)
  if not clients[bufnr] then
    clients[bufnr] = {client_id}
  else
    table.insert(clients[bufnr], client_id)
  end
end

local function on_attach_callback(client, bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()
  vim.notify("Attaching LSP client "..client.id.." to buffer "..bufnr)

  -- register client/buffer relation
  register_buffer(bufnr, client.id)

	-- mappings
	local map = function(type, key, value)
		api.nvim_buf_set_keymap(bufnr, type, key, value,{noremap = true, silent = true});
	end

	map('n', '<Plug>(LspGotoDecl)',          '<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n', '<Plug>(LspGotoImpl)',          '<cmd>lua vim.lsp.buf.implementation()<CR>')
	map('n', '<Plug>(LspGotoTypeDef)',       '<cmd>lua vim.lsp.buf.type_definition()<CR>')
	map('n', '<Plug>(LspFormat)',            '<cmd>lua vim.lsp.buf.formatting()<CR>')
	map('n', '<Plug>(LspIncomingCalls)',     '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	map('n', '<Plug>(LspOutgoingCalls)',     '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
	map('n', '<Plug>(LspHover)',             '<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n', '<Plug>(LspShowSignatureHelp)', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

	--map('n', '<Plug>(LspHover)',             '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
	--map('n', '<Plug>(LspShowSignatureHelp)', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
  map('n', '<Plug>(LspNextDiagnostic)',    '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>')
  map('n', '<Plug>(LspPrevDiagnostic)',    '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>')
	map('n', '<Plug>(LspRename)',            '<cmd>lua require("lspsaga.rename").rename()<CR>')
	map('n', '<Plug>(LspFinder)',            '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>')
	map('n', '<Plug>(LspPreviewDefinition)', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>')
	map('n', '<Plug>(LspShowLineDiagnostics)','<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>')
	map('n', '<Plug>(LspCodeActions)'        ,'<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
	map('n', '<Plug>(LspRangeCodeActions)'   ,':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>')

	map('n', '<Plug>(LspGotoDef)',           '<cmd>lua require"telescope.builtin.lsp".definitions()<CR>')
	map('n', '<Plug>(LspShowReferences)',    '<cmd>lua require"telescope.builtin.lsp".references()<CR>')
	map('n', '<Plug><LspDocumentSymbol)',    '<cmd>lua require"telescope.builtin.lsp".document_symbols()<CR>')
	map('n', '<Plug><LspWorkspaceSymbol)',   '<cmd>lua require"plugins.telescope".lsp_dynamic_symbols()<CR>')

  -- Extensions
  require 'illuminate'.on_attach(client)
  require 'aerial'.on_attach(client)

end

local function setup()

	-- diagnostics signs
  vim.fn.sign_define('LspDiagnosticsSignError', {
    text = ''; texthl = 'LspDiagnosticsSignError';
  })
  vim.fn.sign_define('LspDiagnosticsSignWarning', {
    text = ''; texthl = 'LspDiagnosticsSignWarning';
  })
  vim.fn.sign_define('LspDiagnosticsSignInformation', {
    text = 'i'; texthl = 'LspDiagnosticsSignInformation';
  })
  vim.fn.sign_define('LspDiagnosticsSignHint', {
    text = 'h'; texthl = 'LspDiagnosticsSignHint';
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = true,
      update_in_insert = false,
      underline = true,
      --virtual_text = true,
      virtual_text = {
        spacing = 4,
        prefix = '~',
      },
    }
  )

	-- custom handlers
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = window.window_border_chars
    }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = window.window_border_chars
    }
  )
  -- vim.lsp.handlers['textDocument/references'] = function(_, _, result)
  --   if not result then return end
  --   util.set_qflist(util.locations_to_items(result))
  --   api.nvim_command("botright copen")
  --   api.nvim_command("wincmd p")
  -- end

	-- language servers

	--- Lua
	nvim_lsp.sumneko_lua.setup{
		cmd = {
			"/Users/pwntester/repos/lua-language-server/bin/macOS/lua-language-server",
			"-E",
			"/Users/pwntester/repos/lua-language-server/main.lua",
		};
		on_attach = on_attach_callback;
		settings = {
			Lua = {
				completion = { keywordSnippet = "Disable", },
				diagnostics = { enable = true, globals = {
					"vim", "describe", "it", "before_each", "after_each" },
				},
	      runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					}
				}
			}
		}
	}

	--- JavaScript
	nvim_lsp.tsserver.setup{
		on_attach = on_attach_callback;
	}

	--- Go
	nvim_lsp.gopls.setup{
		on_attach = on_attach_callback;
	}

  --- .NET
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/Users/pwntester/repos/omnisharp-osx/run"
  nvim_lsp.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
		on_attach = on_attach_callback;
  }

	--- CodeQL
  --{"jsonrpc":"2.0","id":0,"result":{"capabilities":{"textDocumentSync":1,"hoverProvider":true,"completionProvider":{"resolveProvider":false,"triggerCharacters":[".",","]},"definitionProvider":true,"referencesProvider":true,"documentHighlightProvider":true,"documentSymbolProvider":true,"documentFormattingProvider":true,"workspace":{"workspaceFolders":{"supported":true,"changeNotifications":true}},"experimental":{"checkErrorsProvider":true,"guessLocationProvider":true}}}}
	nvim_lsp.codeqlls.setup{
		on_attach = on_attach_callback;
    root_dir = function(fname)
      if vim.startswith(fname, "octo:") or vim.startswith(fname, "codeql:") then return end
      local root_pattern = util.root_pattern("qlpack.yml")
      return root_pattern(fname) or util.path.dirname(fname)
    end,
		settings = {
			search_path = vim.g.codeql_search_path;
		};
	}

	--- Fortify Language Server
	if not configs.fortify_lsp then
		configs.fortify_lsp = {
			default_config = {
				cmd = {'fls'};
				filetypes = {'fortifyrulepack'};
				root_dir = function(fname)
					return nvim_lsp.util.path.dirname(fname)
				end;
			};
		}
	end
	nvim_lsp.fortify_lsp.setup{
		on_attach = on_attach_callback;
	}

end

local function start_jdt()
  local bufname = vim.fn.bufname()
  if vim.startswith(bufname, "codeql:") or vim.startswith(bufname, "octo:") then return end
  local root_markers = {'gradlew', 'mwnw', '.git'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local home = os.getenv('HOME')
  local workspace_folder = home .. "/jdt_ws/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  local jdt_capabilities = vim.lsp.protocol.make_client_capabilities()
  jdt_capabilities.workspace.configuration = true
  jdt_capabilities.textDocument.completion.completionItem.snippetSupport = true

  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;

  local config = {
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
      server_side_fuzzy_completion = true
    };
    capabilities = jdt_capabilities;
    init_options = {
      extendedClientCapabilities = extendedClientCapabilities;
    },
    on_init = on_init_callback;
    filetypes = {'java'};
    cmd = {'/Users/pwntester/bin/jdtls', workspace_folder};
    on_attach = function (client, bufnr)
      on_attach_callback(client, bufnr)
      jdtls.setup.add_commands()

      -- mappings
      local map = function(type, key, value)
        api.nvim_buf_set_keymap(bufnr, type, key, value,{noremap = true, silent = true});
      end

      -- TODO: Can we make these look like the saga ones?
      map('n', '<Plug>(LspCodeActions)', '<cmd>lua require("jdtls").code_action()<CR>')
      map('v', '<Plug>(LspRangeCodeActions)', ':<C-U>lua lua require("jdtls").code_action(true)<CR>')
    end,
    settings = {
      java = {
        signatureHelp = { enabled = true };
        contentProvider = { preferred = 'fernflower' };
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*"
          }
        };
        sources = {
          organizeImports = {
            starThreshold = 9999;
            staticStarThreshold = 9999;
          };
        };
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
          }
        };
        configuration = {
          runtimes = {
            -- {
            --   name = "JavaSE-8",
            --   path = "/Users/pwntester/.sdkman/candidates/java/8.0.242.hs-adpt/",
            -- },
            {
              name = "JavaSE-11",
              path = "/Users/pwntester/.sdkman/candidates/java/11.0.6.hs-adpt/",
            }
          }
        };
      };
    }
  }
  jdtls.start_or_attach(config)
end

local function setup_jdt()
  vim.cmd [[augroup lsp]]
  vim.cmd [[au!]]
  vim.cmd [[au FileType java lua require('lsp_config').start_jdt()]]
  vim.cmd [[augroup end]]

  local finders = require'telescope.finders'
  local sorters = require'telescope.sorters'
  local actions = require'telescope.actions'
  local pickers = require'telescope.pickers'
  require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
    local dropdown_opts = require('telescope.themes').get_dropdown({
      results_height = 15;
      width = 0.4;
      prompt_title = '';
      previewer = false;
      borderchars = {
        prompt = window.window_border_chars_telescope_prompt;
        results = window.window_border_chars_telescope_results;
        preview = window.window_border_chars_telescope_preview;
      };
    })
    pickers.new(dropdown_opts, {
      prompt_title = prompt,
      finder    = finders.new_table {
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
	setup = setup;
  start_jdt = start_jdt;
  setup_jdt = setup_jdt;
  clients = clients;
}
