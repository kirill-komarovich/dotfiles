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
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("egrepify")
telescope.load_extension("ui-select")
