local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.load_extension("media_files")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = "ﰲ ",
    path_display = { "absolute" },
    mappings = {
      i = {
        ['<CR>'] = function(args)
          actions.select_default(args)
          actions.center(args)
        end,
        ["<ESC>"] = actions.close,
      },
    },
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
local Keymaps = require("kirillkomarovich.remap")
local nnoremap = Keymaps.nnoremap
local vnoremap = Keymaps.vnoremap

nnoremap("<leader>fr", builtin.resume, { desc = "Resume last telescope picker result" })

nnoremap("<C-p>", function()
  builtin.find_files(themes.get_dropdown({ previewer = false }))
end, { desc = "Find files by path with telescope.find_files" })

nnoremap("<leader>fg", function()
  builtin.live_grep(themes.get_ivy())
end, { desc = "Find files by grep content with telescope.live_grep" })

vnoremap("<leader>fg", function()
  vim.cmd('noau normal! "vy"')
  builtin.grep_string(themes.get_ivy({ default_text = vim.fn.getreg('v') }))
end, { silent = true, desc = "Find files by grep content with telescope.grep_string using current selected text" })

nnoremap("<leader>fbr", function()
  builtin.git_branches(themes.get_dropdown({ previewer = false }))
end, { desc = "Find git branges with telescope.git_branches" })

nnoremap("<leader>fh", builtin.help_tags, { desc = "Find content in help tags with telescope.help_tags" })

nnoremap("<leader>fk", builtin.keymaps, { desc = "Find content in keymaps with with telescope.keymaps" })

nnoremap("<leader>b", function()
  builtin.buffers(themes.get_dropdown({ previewer = false, sort_mru = true }))
end, { desc = "Find opened buffers by path with telescope.buffers" })

nnoremap("<leader>/", function()
  builtin.current_buffer_fuzzy_find(themes.get_ivy())
end, { desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find" })

vnoremap("<leader>/", function()
  vim.cmd('noau normal! "vy"')
  builtin.current_buffer_fuzzy_find(themes.get_ivy({ default_text = vim.fn.getreg('v') }))
end, { desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find using current selected text" })
