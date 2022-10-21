local Keymaps = require("kirillkomaroich.keymaps")
local nnoremap = Keymaps.nnoremap

nnoremap("<C-f>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>")
nnoremap("<C-f>g", "<cmd>lua require'telescope.builtin'.live_grep(require('telescope.themes').get_ivy())<CR>")
