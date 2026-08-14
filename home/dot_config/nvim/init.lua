-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Listen on a per-project address so nvim-open can send files here. This is a
-- second address; vim.v.servername keeps its own random one.
local socket_dir = vim.fn.stdpath("cache") .. "/sockets"
vim.fn.mkdir(socket_dir, "p")
local socket = socket_dir .. "/" .. vim.uv.cwd():gsub("/", "%%") .. ".pipe"
if not pcall(vim.fn.serverstart, socket) then
  -- Taken by a live nvim in this project, or left behind by a crashed one.
  if not pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true }) then
    vim.uv.fs_unlink(socket)
    pcall(vim.fn.serverstart, socket)
  end
end

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
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "81,120"
vim.opt.conceallevel = 0
vim.opt.cmdheight = 1
-- Buffers open unfolded; treesitter folding is opt-in via zc/zM.
vim.opt.foldlevelstart = 99

-- disable netrw
vim.g.loaded_netrw = 1
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
