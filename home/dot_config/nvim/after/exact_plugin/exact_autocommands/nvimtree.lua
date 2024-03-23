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

nvim_create_autocmd("BufEnter", {
  group = NvimTreeGroup,
  nested = true,
  callback = function()
    local api = require('nvim-tree.api')

    -- Only 1 window with nvim-tree left: we probably closed a file buffer
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      -- Required to let the close event complete. An error is thrown without this.
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last hidden buffer used before closing
        api.tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        api.tree.toggle({find_file = true, focus = true})
        -- nvim-tree is still the active window. Go to the previous window.
        vim.cmd("wincmd p")
      end, 0)
    end
  end
})
