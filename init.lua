-- Get path to lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is installed
if not vim.loop.fs_stat(lazypath) then
 -- If not installed, clone it from GitHub
 vim.fn.system({
   "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
 })
end

-- Prepend Lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/init.lua
require("plugins")

-- file explorer
require("nvim-tree").setup()
