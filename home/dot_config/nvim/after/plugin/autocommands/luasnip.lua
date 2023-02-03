local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd

LuasnipGroup = nvim_create_augroup('LuasnipGroup', { clear = true })

-- Stop snippets when you leave to normal mode
nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  group = LuasnipGroup,
  callback = function ()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active then
      require('luasnip').unlink_current()
    end
  end,
})
