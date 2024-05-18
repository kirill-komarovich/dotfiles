local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command

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
  callback = function ()
    vim.cmd.setlocal("indentkeys-=.")

    local pairs = require("mini.pairs")
    pairs.map_buf(0, "i", "|", { action = "closeopen", pair = "||" })
  end
})

local oil_inited = false

autocmd({ "FileType" }, {
  group = augroup("oil", { clear = true }),
  pattern = "oil",
  callback = function ()
    if oil_inited then
      return
    end

    oil_inited = true

    local buffer_name = vim.api.nvim_buf_get_name(0)
    local ending = ".local/share/chezmoi/"

    if buffer_name:sub(-#ending) == ending then
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
