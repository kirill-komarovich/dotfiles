local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    themable = true,
    tab_size = 22,
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
  }
})

