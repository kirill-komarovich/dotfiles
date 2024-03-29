local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command

GeneralGroup = nvim_create_augroup("General", { clear = true })
RubyGroup = nvim_create_augroup("Ruby", { clear = true })

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

nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = RubyGroup,
  callback = function()
    vim.cmd.setlocal("indentkeys-=.")
  end
})

nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.jbuilder,Dangerfile",
  group = RubyGroup,
  callback = function()
    vim.cmd.set("ft=ruby")
  end
})

PackagesGroup = nvim_create_augroup('Packages', { clear = true })

nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  group = PackagesGroup,
  callback = function()
    require("lazy").sync()
  end,
})
