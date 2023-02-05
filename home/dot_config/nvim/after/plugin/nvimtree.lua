require("nvim-tree").setup({
  disable_netrw = true,
  open_on_tab = false,
  hijack_cursor = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = { "doc" },
  },
  diagnostics = {
    enable = true,
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 1000,
  },
  view = {
    width = 50,
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "all",
    root_folder_modifier = ":t",
    indent_markers = {
      enable = true,
      icons = { corner = "│", edge = "│", item = "│", none = " ", }
    },
    icons = {
      show = {
        git = false,
      },
      glyphs = {
        default  = "",
        symlink = "",
        folder = {
          default = "",
          open = "",
          arrow_closed = "",
          arrow_open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
    special_files = {
      "Cargo.toml",
      "Makefile",
      "README.md",
      "readme.md",
      "Gemfile",
      "mix.exs",
      "package.json",
    },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
})
