local gitsigns = require("gitsigns")
local Keymaps = require("kirillkomaroich.remap")
local nnoremap = Keymaps.nnoremap
local vnoremap = Keymaps.vnoremap

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local bufopts = { silent = true, buffer = bufnr }
    -- Actions
    nnoremap("<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", bufopts)
    vnoremap("<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", bufopts)
    nnoremap("<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", bufopts)
    vnoremap("<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", bufopts)
    nnoremap("<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", bufopts)
    nnoremap("<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", bufopts)
    nnoremap("<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", bufopts)
    nnoremap("<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", bufopts)
    nnoremap("<leader>hb", "<cmd>Gitsigns blame_line<CR>", bufopts)
    nnoremap("<leader>hB", function () gitsigns.blame_line({ full = true }) end, bufopts)
    nnoremap("<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", bufopts)
    nnoremap("<leader>hd", "<cmd>Gitsigns diffthis<CR>", bufopts)
    nnoremap("<leader>hD", function() gitsigns.diffthis("~") end, bufopts)
    nnoremap("<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", bufopts)

    -- Text object
    -- map({'o', 'x'}, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
  end,
}
