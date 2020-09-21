local function setup()
  require'snippets'.set_ux(require'snippets.inserters.floaty')
  --require'snippets'.set_ux(require'snippets.inserters.vim_input')
  --require'snippets'.set_ux(require'snippets.inserters.text_markers')
  require'snippets.contrib.clippy'.setup()
  require'snippets.contrib.clippy'.message_template = [[ You have a snippet for that: %q ]]
  require'snippets'.snippets = {
    lua = {
      -- Courtesy of @norcalli
      ['func']    = [[function${1|vim.trim(S.v):gsub('^%S',' %0')}(${2|vim.trim(S.v)})$0 end]];
      ['req']     = [[local ${2:${1|(S.v:match('([^.()]+)[()]*$') or ''):gsub('%-+','_')}} = require '$1']];
      ['local']   = [[local ${2:${1|S.v:match'[^.]+$'}} = ${1}]];
      ['for']     = [[for ${1:i}, ${2:v} in ipairs(${3:t}) do\n$0\nend]];
      ['vmap']    = [[vim.tbl_map(function(x) return ${1:x} end, ${2:t})]];
      ['vfilter'] = [[vim.tbl_filter(function(x) return ${1:x} == ${2} end, ${3:t})]];
    }
  }
end

return {
  setup = setup;
}

