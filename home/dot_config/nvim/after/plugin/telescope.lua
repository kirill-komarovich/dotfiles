local telescope = require("telescope")

telescope.load_extension("media_files")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = "ﰲ ",
    path_display = { "absolute" },
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = { "png", "webp", "jpg", "jpeg" },
      -- find_cmd = "rg" -- find command (defaults to `fd`)
    }
  },
})

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local Keymaps = require("kirillkomaroich.remap")
local nnoremap = Keymaps.nnoremap
local vnoremap = Keymaps.vnoremap

nnoremap("<C-f>r", builtin.resume, { desc = "Resume last telescope picker result" })

nnoremap("<C-f>f", function()
  builtin.find_files(themes.get_dropdown({ previewer = false }))
end, { desc = "Find files by path with telescope.find_files" })

nnoremap("<C-f>g", function()
  builtin.live_grep(themes.get_ivy())
end, { desc = "Find files by grep content with telescope.live_grep" })

vnoremap("<C-f>g", function()
  vim.cmd('noau normal! "vy"')
  builtin.grep_string(themes.get_ivy({ default_text = vim.fn.getreg('v') }))
end, { silent = true, desc = "Find files by grep content with telescope.grep_string using current selected text" })

nnoremap("<leader>b", function()
  builtin.buffers(themes.get_dropdown({ previewer = false, sort_mru = true }))
end, { desc = "Find opened buffers by path with telescope.buffers" })

nnoremap("<C-_>", function()
  builtin.current_buffer_fuzzy_find(themes.get_ivy())
end, { desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find" })
