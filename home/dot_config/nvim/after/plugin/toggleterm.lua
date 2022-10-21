require("toggleterm").setup({
  direction = "float",
  float_opts = {
    border = 'single',
  },
})

local Terminal = require("toggleterm.terminal").Terminal

local client = Terminal:new({
  cmd = "gitui",
  hidden = true,
})

vim.api.nvim_create_user_command("GitUIToggle", function()
  client:toggle()
end, {})
