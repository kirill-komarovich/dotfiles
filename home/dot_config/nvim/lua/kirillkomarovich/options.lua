-- :help options
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbers
vim.opt.swapfile = false -- creates a swapfile
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.showtabline = 2 -- always show tabs
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.fileformat = "unix" -- This gives the <EOL> of the current buffer
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.cursorline = true -- highlight the current line
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.colorcolumn = "81,120" -- rulers
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1 -- Give more space for displaying messages.
vim.opt.spelllang = "en"
-- disable netrw
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.g.completeopt = "menu,menuone,noselect"

vim.g.mapleader = " "


vim.filetype.add({
  extension = {
    jbuilder = "ruby",
  },
  filename = {
    Dangerfile = "ruby",
  },
})
