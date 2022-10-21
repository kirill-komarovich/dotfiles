local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command

-- Trim Whitespaces at the end of line
nvim_create_autocmd("BufWritePre", { pattern = "*", callback = function ()
  nvim_command("%s/\\s\\+$//e")
end })

-- Trim blank lines at the end of file
nvim_create_autocmd("BufWritePre", { pattern = "*", callback = function ()
  nvim_command("%s/\\($\\n\\s*\\)\\+\\%$//e")
end })

-- Stop snippets when you leave to normal mode
nvim_create_autocmd("ModeChanged", { pattern = "*", callback = function ()
  if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active then
    require('luasnip').unlink_current()
  end
end})

-- Close window if no buffers left
-- local modifiedBufs = function(bufs)
--     local t = 0
--     for k,v in pairs(bufs) do
--         if v.name:match("NvimTree_") == nil then
--             t = t + 1
--         end
--     end
--     return t
-- end
--
-- nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and
--       vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil and
--       modifiedBufs(vim.fn.getbufinfo({bufmodified = 1})) == 0 then
--       vim.cmd "quit"
--     end
--   end
-- })
