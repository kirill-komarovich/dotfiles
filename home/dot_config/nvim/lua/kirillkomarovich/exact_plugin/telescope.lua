local telescope = require("telescope")
local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = "",
    path_display = { "absolute" },
    mappings = {
      i = {
        ["<CR>"] = function(args)
          actions.select_default(args)
          actions.center(args)
        end,
      },
      n = {
        ["D"] = "delete_buffer",
        ["tp"] = layout_actions.toggle_preview,
      }
    },
  },
  extensions = {
    media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
    },
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
    },
  },
})

telescope.load_extension("media_files")
telescope.load_extension("fzf")
telescope.load_extension("egrepify")
telescope.load_extension("ui-select")
