local lsp = require "vim.lsp"
local jdtls = require "jdtls"

local bufname = vim.fn.bufname()
if not vim.startswith(bufname, "codeql:") and not vim.startswith(bufname, "octo:") then
  local root_markers = { "gradlew", "mwnw", ".git", "pom.xml" }
  local root_dir = require("jdtls.setup").find_root(root_markers)

  local VERSION = "1.6.400.v20210924-0641"

  local HOME = os.getenv "HOME"
  local JDTLS_HOME = HOME .. "/jdt_ws"
  local JAVA_HOME = HOME .. "/.sdkman/candidates/java/11.0.6.hs-adpt/"
  local LAUNCHER = JDTLS_HOME
      .. "/jdt-language-server-latest/plugins/org.eclipse.equinox.launcher_"
      .. VERSION
      .. ".jar"
  local CONFIGURATION = JDTLS_HOME .. "/jdt-language-server-latest/config_mac"
  local DATA = JDTLS_HOME .. "/workspace-root/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.workspace.configuration = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local config = {
    cmd = {
      JAVA_HOME .. "/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      LAUNCHER,
      "-configuration",
      CONFIGURATION,
      "-data",
      DATA,
    },

    flags = {
      allow_incremental_sync = true,
    },
    -- handlers = {
    --   ["textDocument/publishDiagnostics"] = lsp_diag.publishDiagnostics,
    -- },
    capabilities = capabilities,
    on_init = function(client)
      if client.config.settings then
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
    end,
    on_attach = function(_, bufnr)
      require("jdtls.setup").add_commands()
      local mappings = require "pwned.mappings"
      g.map(mappings.lsp, { silent = false }, bufnr)
      g.map(mappings.lsp_jdt, { silent = false }, bufnr)
    end,
    root_dir = root_dir,
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
            {
              name = "JavaSE-11",
              path = HOME .. "/.sdkman/candidates/java/11.0.6.hs-adpt/",
            },
          },
        },
      },
    },
    init_options = {
      bundles = {},
      extendedClientCapabilities = extendedClientCapabilities,
    },
  }
  require("jdtls").start_or_attach(config)
end
