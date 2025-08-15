local M = {}

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
local function bind(mode, outer_opts)
  outer_opts = outer_opts or { noremap = true }

  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force",
      outer_opts,
      opts or {}
    )
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

M.map = vim.keymap.set
M.noremap = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force",
    { noremap = true },
    opts or {}
  )
  vim.keymap.set(mode, lhs, rhs, opts)
end
M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")

return M
