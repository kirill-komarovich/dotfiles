local function load(fn)
  return function()
    return fn({
      builtin = require("telescope.builtin"),
      themes = require("telescope.themes"),
      egrepify = require('telescope').extensions.egrepify.egrepify,
    })
  end
end

local M = {}

-- Files
table.insert(M, {
  "<C-p>",
  load(function(telescope)
    telescope.builtin.find_files(telescope.themes.get_dropdown({ previewer = false }))
  end),
  desc = "Find files by path with telescope.find_files",
})
table.insert(M, {
  "<C-p>",
  load(function(telescope)
    vim.cmd('noau normal! "vy"')
    telescope.builtin.find_files(telescope.themes.get_dropdown({
      previewer = false,
      default_text = vim.fn.getreg("v"),
    }))
  end),
  mode = "v",
  desc = "Find files by path with telescope.find_files using current selected text",
})
table.insert(M, {
  "<leader>fg",
  load(function(telescope)
    telescope.egrepify(telescope.themes.get_ivy())
  end),
  desc = "Find files by grep content with telescope.live_grep",
})
table.insert(M, {
  "<leader>fg",
  load(function(telescope)
    vim.cmd('noau normal! "vy"')
    telescope.egrepify(telescope.themes.get_ivy({ default_text = vim.fn.getreg("v") }))
  end),
  mode = "v",
  silent = true,
  desc = "Find files by grep content with telescope.grep_string using current selected text",
})

-- Utils
table.insert(M, {
  "<leader>fr",
  load(function(telescope)
    telescope.builtin.resume()
  end),
  desc = "Resume last telescope picker result",
})
table.insert(M, {
  "<leader>fh",
  load(function(telescope)
    telescope.builtin.help_tags()
  end),
  desc = "Find content in help tags with telescope.help_tags",
})
table.insert(M, {
  "<leader>fk",
  load(function(telescope)
    telescope.builtin.keymaps()
  end),
  desc = "Find content in keymaps with with telescope.keymaps",
})

-- Buffers
table.insert(M, {
  "<leader>b",
  load(function(telescope)
    telescope.builtin.buffers(telescope.themes.get_dropdown({
      previewer = false,
      sort_mru = true,
      initial_mode = "normal",
    }))
  end),
  desc = "Find opened buffers by path with telescope.buffers",
})
table.insert(M, {
  "<leader>/",
  load(function(telescope)
    telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_ivy())
  end),
  desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find",
})
table.insert(M, {
  "<leader>/",
  load(function(telescope)
    vim.cmd('noau normal! "vy"')
    telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_ivy({ default_text = vim.fn.getreg("v") }))
  end),
  desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find using current selected text",
})

-- Git
table.insert(M, {
  "<leader>gb",
  load(function(telescope)
    telescope.builtin.git_branches(telescope.themes.get_dropdown({ previewer = false }))
  end),
  desc = "Find git branges with telescope.git_branches",
})
table.insert(M, {
  "<leader>ga",
  load(function(telescope)
    telescope.builtin.git_status({ initial_mode = "normal", results_title = "", preview_title = "" })
  end),
  desc = "Find files in current git status",
})
table.insert(M, {
  "<leader>gc",
  load(function(telescope)
    telescope.builtin.git_commits({ initial_mode = "normal", results_title = "", preview_title = "" })
  end),
  desc = "Find git commits",
})
table.insert(M, {
  "<leader>gh",
  load(function(telescope)
    telescope.builtin.git_bcommits({ initial_mode = "normal", results_title = "", preview_title = "" })
  end),
  desc = "Find current file git history",
})

return M
