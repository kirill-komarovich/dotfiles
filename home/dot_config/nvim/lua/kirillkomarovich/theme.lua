vim.opt.background = "dark"

local colors = require('vscode.colors').get_colors()

require('vscode').setup({
  transparent = true,
  italic_comments = true,
  disable_nvimtree_bg = true,
});

vim.cmd[[colorscheme vscode]]

local pink = "#f075aa"
local nvim_tree_file_icon_color = "#C5C5C5"

local ruby_color = colors.vscRed
local docker_color = colors.vscLightBlue
local docker_compose_color = pink

local hl = vim.api.nvim_set_hl
hl(0, 'GitSignsChange', { fg = colors.vscBlue, bg = 'NONE' })
hl(0, 'NvimTreeFolderIcon', { fg = nvim_tree_file_icon_color, bg = 'NONE' })

local ruby_icon = ""
local docker_icon = ""

require('nvim-web-devicons').setup({
  override = {
    ["rb"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Rb",
    },
    ["rake"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Rb",
    },
    ["config.ru"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Rb",
    },
    ["Capfile"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Capfile",
    },
    ["gemspec"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Gemspec",
    },
    ["Gemfile$"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Gemfile",
    },
    ["Gemfile"] = {
      icon = ruby_icon,
      color = ruby_color,
      cterm_color = "52",
      name = "Gemfile",
    },
    ["Dockerfile"] = {
      icon = docker_icon,
      color = docker_color,
      cterm_color = "59",
      name = "Dockerfile",
    },
    ["dockerfile"] = {
      icon = docker_icon,
      color = docker_color,
      cterm_color = "59",
      name = "Dockerfile",
    },
    ["docker-compose.yml"] = {
      icon = docker_icon,
      color = docker_compose_color,
      cterm_color = "59",
      name = "DockerCompose",
    },
  },
  default = true,
})
