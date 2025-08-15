local Keymaps = require("kirillkomarovich.remap")

local noremap = Keymaps.noremap

noremap("n", "<ESC>", ":noh<CR>", { silent = true })

-- Buffers
noremap("n", "<leader><TAB>", "<CMD>b#<CR>")

-- Move text up and down
noremap({ "n", "i" }, "<A-j>", "<ESC>:m .+1<CR>==")
noremap({ "n", "i" }, "<A-k>", "<ESC>:m .-2<CR>==")
noremap({ "n", "i" }, "<A-DOWN>", "<ESC>:m .+1<CR>==")
noremap({ "n", "i" }, "<A-UP>", "<ESC>:m .-2<CR>==")
noremap("v", "<A-j>", ":m '>+1<CR>gv=gv")
noremap("v", "<A-DOWN>", ":m '>+1<CR>gv=gv")
noremap("v", "<A-k>", ":m '<-2<CR>gv=gv")
noremap("v", "<A-UP>", ":m '<-2<CR>gv=gv")

-- Navigation
-- Scroll and center in the view
noremap("n", "<C-d>", "<C-d>zz")
noremap("n", "<C-u>", "<C-u>zz")

-- Search
noremap("n", "n", "nzzzv")
noremap("n", "N", "Nzzzv")

-- Paste without adding to register inside visual block
noremap("x", "p", "\"_dP")
