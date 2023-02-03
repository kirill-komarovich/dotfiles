local Keymaps = require("kirillkomaroich.keymaps")
local nnoremap = Keymaps.nnoremap
-- local vnoremap = Keymaps.vnoremap

nnoremap("<C-f>f", "<cmd>Telescope find_files<CR>")
nnoremap("<C-f>g", "<cmd>Telescope live_grep<CR>")
nnoremap("<C-f>b", "<cmd>Telescope buffers<CR>")
nnoremap("<C-_>", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
-- vnoremap("<C-f>g", "zy<cmd>Telescope grep_string default_text=escape(@z, ' ')<CR>")
