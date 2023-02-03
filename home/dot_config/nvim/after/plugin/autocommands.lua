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

-- Open NvimTree on neovim startup
nvim_create_autocmd("VimEnter", {
  callback = function (data)
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    -- buffer is directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if no_name then
      return
    end

    if not real_file and not directory then
      return
    end

    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
    end

    require("nvim-tree.api").tree.toggle({ focus = false, find_file = not directory, update_root = true })
  end,
  group = GeneralGroup,
})
