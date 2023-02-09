require("bufferline").setup({
  options = {
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    diagnostics = "nvim_lsp",
    themable = true,
    tab_size = 22,
    offsets = { { filetype = "NvimTree" } },
    persist_buffer_sort = false,
    sort_by = "insert_after_current",
  }
})
