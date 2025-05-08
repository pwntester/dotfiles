local g = require("pwntester.globals")
local capabilities = require("blink.cmp").get_lsp_capabilities()
local keymap = vim.keymap

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)

    -- Use LSP as the handler for formatexpr.
    vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr")

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }
    
    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
    
    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  end
})
-- configure diagnostics
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  update_in_insert = false,
  severity_sort = false,
})

local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
local server_name = vim.fn.fnamemodify(f, ':t:r')
table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)
