-- Mappings
local mappings = require("pwntester.mappings").markdown
g.map(mappings, { silent = true, noremap = true }, vim.api.nvim_get_current_buf())
