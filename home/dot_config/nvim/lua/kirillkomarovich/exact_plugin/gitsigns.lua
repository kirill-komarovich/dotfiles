local gitsigns = require("gitsigns")
local Keymaps = require("kirillkomarovich.remap")
local nnoremap = Keymaps.nnoremap
local vnoremap = Keymaps.vnoremap

gitsigns.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
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
})
