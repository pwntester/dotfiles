local M = {}

return setmetatable({}, {
  __index = function(_, k)
    --reloader()
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})
