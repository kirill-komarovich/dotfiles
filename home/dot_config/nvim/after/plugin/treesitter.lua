require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "ruby",
    "elixir",
    "eex",
    "heex",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "json",
    "markdown",
    "lua",
  },
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
