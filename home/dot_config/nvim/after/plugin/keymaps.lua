local Keymaps = require("kirillkomarovich.remap")

local nnoremap = Keymaps.nnoremap
local inoremap = Keymaps.inoremap
local vnoremap = Keymaps.vnoremap
local xnoremap = Keymaps.xnoremap

nnoremap('<ESC>', ':noh<CR>', { silent = true })

-- Buffers
nnoremap('<leader><TAB>', '<CMD>b#<CR>')

-- Move text up and down
nnoremap("<A-j>", "<ESC>:m .+1<CR>==")
nnoremap("<A-DOWN>", "<ESC>:m .+1<CR>==")
nnoremap("<A-k>", "<ESC>:m .-2<CR>==")
nnoremap("<A-UP>", "<ESC>:m .-2<CR>==")
inoremap("<A-j>", "<Esc>:m .+1<CR>==gi")
inoremap("<A-DOWN>", "<Esc>:m .+1<CR>==gi")
inoremap("<A-k>", "<Esc>:m .-2<CR>==gi")
inoremap("<A-UP>", "<Esc>:m .-2<CR>==gi")
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-DOWN>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")
vnoremap("<A-UP>", ":m '<-2<CR>gv=gv")

-- Navigation
-- Scroll and center in the view
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Search
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")

-- Paste without adding to register inside visual block
xnoremap("p", "\"_dP")

-- NvimTree
nnoremap("<C-b>", ":NvimTreeToggle<CR>")

-- Toggleterm
nnoremap("<leader>g", ":GitUIToggle<CR>")
