local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command

GeneralGroup = nvim_create_augroup('General', { clear = true })

-- Trim Whitespaces at the end of line
nvim_create_autocmd("BufWritePre", { pattern = "*", group = GeneralGroup, callback = function ()
  nvim_command("%s/\\s\\+$//e")
end })

-- Trim blank lines at the end of file
nvim_create_autocmd("BufWritePre", { pattern = "*", group = GeneralGroup, callback = function ()
  nvim_command("%s/\\($\\n\\s*\\)\\+\\%$//e")
end })

-- Stop snippets when you leave to normal mode
nvim_create_autocmd("ModeChanged", { pattern = "*", group = GeneralGroup, callback = function ()
  if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active then
    require('luasnip').unlink_current()
  end
end})
