vim.opt.background = "dark"

local colors = require("vscode.colors").get_colors()

require("vscode").setup({
  style = "dark",
  transparent_background = false,
  italic_comments = true,
  group_overrides = {
    OilDir = { fg = colors.vscFront, bg = 'NONE' },
    OilDirIcon = { fg = "#c5c5c5", bg = "NONE" },
    GitSignsChange = { fg = colors.vscBlue, bg = "NONE" },
    ["@string.special.symbol"] = { fg = colors.vscBlue, bg = "NONE" },
    ["@tag.javascript"] = { fg = colors.vscBlueGreen, bg = 'NONE' },
  },
});

local pink = "#f075aa"
local ruby_color = colors.vscRed
local docker_color = colors.vscLightBlue
local docker_compose_color = pink

local ruby_icon = ""
local docker_icon = ""

local function ruby_config(name)
  return {
    icon = ruby_icon,
    color = ruby_color,
    cterm_color = "52",
    name = name,
  }
end

require("nvim-web-devicons").setup({
  override = {
    rb = ruby_config("Rb"),
    rake = ruby_config("Rake"),
    ["config.ru"] = ruby_config("ConfigRu"),
    gemspec = ruby_config("Gemspec"),
    gemfile = ruby_config("Gemfile"),
    rakefile = ruby_config("Rakefile"),
    dangerfile = ruby_config("Dangerfile"),
    dockerfile = {
      icon = docker_icon,
      color = docker_color,
      cterm_color = "59",
      name = "dockerfile",
    },
    [".dockerignore"] = {
      icon = docker_icon,
      color = "#458ee6",
      cterm_color = "68",
      name = "Dockerfile",
    },
    ["docker-compose.*"] = {
      icon = docker_icon,
      color = docker_compose_color,
      cterm_color = "59",
      name = "Dockerfile",
    },
    ["pnpm-lock.yaml"] = {
      icon = "",
      color = "#bbbbbb",
      cterm_color = "250",
      name = "PnpmLockYaml",
    },
  },
})

vim.cmd [[colorscheme vscode]]
