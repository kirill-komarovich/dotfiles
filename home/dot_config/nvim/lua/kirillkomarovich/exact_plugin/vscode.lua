vim.opt.background = "dark"

local colors = require("vscode.colors").get_colors()
local file_icon_color = "#c5c5c5"

require("vscode").setup({
  style = "dark",
  transparent_background = false,
  italic_comments = true,
  group_overrides = {
    OilDir = { fg = colors.vscFront, bg = 'NONE' },
    OilDirIcon = { fg = file_icon_color, bg = "NONE" },
    GitSignsChange = { fg = colors.vscBlue, bg = "NONE" },
    ["@string.special.symbol"] = { fg = colors.vscBlue, bg = "NONE" },
    ["@tag.javascript"] = { fg = colors.vscBlueGreen, bg = 'NONE' },
  },
});
