local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local M = {}

local with_diagnostics_code = function(builtin)
  return builtin.with {
    -- #{m} displays the message, and #{c} displays the code if available.
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md?#diagnostics-format
    diagnostics_format = "#{m} [#{c}]",
  }
end

local with_root_file = function(builtin, file)
  -- make sure we have the configuration files for the sources
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  }
end

local sources = {
  -- formatting

  --- prettierd to format file types of javascript, javascriptreact, typescript, typescriptreact, vue, css, scss, less, html, json, yaml, markdown, and graphql.
  b.formatting.prettierd,

  --- to format shell scripts.
  b.formatting.shfmt,

  --- to format JSON files.
  b.formatting.fixjson,

  --- to format and sort Python code.
  b.formatting.black.with { extra_args = { "--fast" } },
  b.formatting.isort,

  --- to format Lua code.
  with_root_file(b.formatting.stylua, ".stylua.toml"),

  -- diagnostics

  --- for Markdown files
  b.diagnostics.write_good,
  b.diagnostics.markdownlint,

  --- for Python code
  b.diagnostics.flake8.with { extra_args = { "--ignore=E501" } },
  b.diagnostics.mypy,

  --- for typescript code
  b.diagnostics.eslint,
  b.diagnostics.tsc,

  --- for Lua code
  with_root_file(b.diagnostics.selene, "selene.toml"),

  --- for shell scripts
  with_diagnostics_code(b.diagnostics.shellcheck),

  -- code actions

  --- actions for Git operations at the current cursor position (stage/preview/reset hunks, blame, etc.).
  b.code_actions.gitsigns,

  --- actions to change thegitrebase command. (eg. using squash instead of pick).
  b.code_actions.gitrebase,

  -- hover

  --- shows the first available definition for the current word under the cursor, using dictionaryapi.dev.
  b.hover.dictionary,
}

function M.setup(opts)
  opts = opts or {}
  nls.setup {
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern ".git",
  }
end

return M
