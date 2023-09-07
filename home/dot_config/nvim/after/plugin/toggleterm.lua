require("toggleterm").setup({})

local Keymaps = require("kirillkomarovich.remap")
local nnoremap = Keymaps.nnoremap

local Terminal = require("toggleterm.terminal").Terminal

local client = Terminal:new({
  cmd = "gitui",
  hidden = true,
  direction = "float",
  float_opts = {
    border = 'single',
  },
})

vim.api.nvim_create_user_command("GitUIToggle", function()
  client:toggle()
end, {})

-- Toggleterm
nnoremap("<leader>gu", ":GitUIToggle<CR>", { silent = true })
