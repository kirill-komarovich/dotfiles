local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  open_on_tab = true,
  hijack_cursor = false,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = { "doc" },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  view = {
    width = 50,
    height = 30,
    side = "left",
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "all",
    root_folder_modifier = ":t",
    icons = {
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
        git = {
          unstaged = "",
          ignored = "",
          untracked = "",
          staged = "",
          deleted = "",
        },
      },
    },
    indent_markers = {
      enable = true,
      icons = { corner = "│", edge = "│", item = "│", none = " ", }
    }
  },
}

