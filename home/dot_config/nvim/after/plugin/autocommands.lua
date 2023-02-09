local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command

GeneralGroup = nvim_create_augroup('General', { clear = true })

-- Trim Whitespaces at the end of line
nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = GeneralGroup,
  callback = function()
    nvim_command("%s/\\s\\+$//e")
  end,
})

-- Trim blank lines at the end of file
nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = GeneralGroup,
  callback = function()
    nvim_command("%s/\\($\\n\\s*\\)\\+\\%$//e")
  end,
})
