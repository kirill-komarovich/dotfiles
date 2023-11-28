local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd

NvimTreeGroup = nvim_create_augroup('NvimTreeGroup', { clear = true })

-- Open NvimTree on neovim startup
nvim_create_autocmd("VimEnter", {
  group = NvimTreeGroup,
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

    if vim.fn.isdirectory(".git") == 1 then
      require("nvim-tree.api").tree.toggle({ focus = false, find_file = not directory, update_root = true })
    end
  end,
})
