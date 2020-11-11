function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local function setup()
  vim.g.completion_confirm_key = ""
  vim.g.completion_enable_auto_paren = true
  vim.g.completion_enable_snippet = 'snippets.nvim'
  vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
  vim.g.completion_chain_complete_list = {
	  default = {
			default = {
        { complete_items = {'lsp', 'ts', 'snippet'} },
        { complete_items = { 'buffers' } },
        { mode = 'file' },
      },
			comment = {
        { complete_items = { 'buffers' } },
      },
			string = {
        { complete_items = { 'buffers' } },
      },
	  },
	}
  vim.cmd [[ au BufEnter * lua require'completion'.on_attach() ]]
end

return {
  setup = setup;
}
