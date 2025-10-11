-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "81,120"
vim.opt.conceallevel = 0
vim.opt.cmdheight = 1

-- disable netrw
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.filetype.add({
  extension = {
    jbuilder = "ruby",
  },
  filename = {
    Dangerfile = "ruby",
    Fastfile = "ruby",
    Appfile = "ruby",
    Pluginfile = "ruby",
  },
})

require("kirillkomarovich.plugins")
