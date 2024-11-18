local M = {}

M.servers = {
  -- lspconfig name : mason name
  pyright = "pyright",
  bashls = "bash-language-server",
  lua_ls = "lua-language-server",
  ts_ls = "ts_ls",
  gopls = "gopls",
  codeqlls = "codeql",
  yamlls = "yaml-language-server",
  jsonls = "json-lsp",
  dockerls = "dockerfile-language-server",
  markdown_oxide = "markdown-oxide",
}

function M.get_clients(opts)
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

return M
