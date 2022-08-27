local trim_whitespaces = function ()
  vim.api.nvim_command("%s/\\s\\+$//e")
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = trim_whitespaces,
})
