local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command
local nnoremap = require("kirillkomarovich.remap").nnoremap

-- Trim Whitespaces at the end of line
-- Trim blank lines at the end of file
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("general-settings", { clear = true }),
  callback = function()
    nvim_command("%s/\\($\\n\\s*\\)\\+\\%$//e")
    nvim_command("%s/\\s\\+$//e")
  end,
})

autocmd({ "FileType" }, {
  group = augroup("ruby-settings", { clear = true }),
  pattern = "ruby",
  callback = function()
    vim.cmd.setlocal("indentkeys-=.")

    local pairs = require("mini.pairs")
    pairs.map_buf(0, "i", "|", { action = "closeopen", pair = "||" })
  end
})

local oil_inited = false

autocmd({ "FileType" }, {
  group = augroup("oil", { clear = true }),
  pattern = "oil",
  callback = function()
    local function copy_file_path()
      local oil = require('oil')
      local nvim_cwd = vim.fn.getcwd()
      local oil_cwd = oil.get_current_dir()
      local entry = oil.get_cursor_entry()

      if not entry then
        print("No file selected.")
        return
      end

      local full_path = oil_cwd .. entry.name
      local relative_path = full_path:gsub("^" .. vim.pesc(nvim_cwd .. "/"), "")
      vim.fn.setreg('+', relative_path)

      print("Copied path: " .. relative_path)
    end

    nnoremap("Y", copy_file_path, { buffer = true })

    if not oil_inited then
      oil_inited = true
      require("oil.actions").tcd.callback()
    end
  end
})

autocmd({ "BufWritePost" }, {
  pattern = "plugins.lua",
  group = augroup("packages", { clear = true }),
  callback = function()
    require("lazy").sync()
  end,
})
