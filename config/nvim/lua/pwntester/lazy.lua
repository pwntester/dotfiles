local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  dev = {
    path = "~/src/github.com/pwntester",
    patterns = { "pwntester" },
  },
  install = {
    missing = true,
  },
  defaults = {
  },
}

local specs = {
  { import = "pwntester.plugins" },
}

require("lazy").setup(specs, opts)
