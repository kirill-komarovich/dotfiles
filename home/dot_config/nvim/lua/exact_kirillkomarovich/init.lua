P = function(value)
  print(vim.inspect(value))
  return value
end

RELOAD = function(name)
  return require("plenary.reload").reload_module(name)
end

R = function(name)
  RELOAD(name)
  return require(name)
end


-- :help options
vim.o.mouse = "a" -- allow the mouse to be used in neovim
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8" -- the encoding written to a file
vim.o.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.o.number = true -- set numbered lines
vim.o.relativenumber = true -- set relative numbers
vim.o.swapfile = false -- creates a swapfile
vim.o.smartcase = true -- smart case
vim.o.smartindent = true -- make indenting smarter again
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.showtabline = 2 -- always show tabs
vim.o.tabstop = 2 -- insert 2 spaces for a tab
vim.o.softtabstop = 2
vim.o.expandtab = true -- convert tabs to spaces
vim.o.fileformat = "unix" -- This gives the <EOL> of the current buffer
vim.o.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.o.cursorline = true -- highlight the current line
vim.o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.o.conceallevel = 0 -- so that `` is visible in markdown files
vim.o.colorcolumn = "81,120" -- rulers
vim.o.cmdheight = 1 -- Give more space for displaying messages.
vim.o.spelllang = "en"
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
  pattern = {
    ["Dockerfile%..*"] = "dockerfile",
  }
})

require("kirillkomarovich.plugins")
