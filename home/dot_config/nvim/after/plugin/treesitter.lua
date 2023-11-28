require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "" } },
  playground = {
    enable = true,
  }
}
