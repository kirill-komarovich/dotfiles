local telescope = require("telescope")

telescope.load_extension("media_files")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    live_grep = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
    current_buffer_fuzzy_find = {
      theme = "ivy",
    },
    buffers = {
      sort_mru = true,
    },
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = {"png", "webp", "jpg", "jpeg"},
      -- find_cmd = "rg" -- find command (defaults to `fd`)
    }
  },
})
