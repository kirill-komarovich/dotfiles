local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command
local noremap = require("kirillkomarovich.remap").noremap

-- Trailing whitespace is significant in these (markdown hard breaks, diff context).
local keep_trailing_whitespace = { markdown = true, diff = true, gitcommit = true, gitsendemail = true }

-- Trim Whitespaces at the end of line
-- Trim blank lines at the end of file
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("general-settings", { clear = true }),
  callback = function(args)
    if keep_trailing_whitespace[vim.bo[args.buf].filetype] then
      return
    end

    -- keeppatterns + winrestview so the write leaves the search register,
    -- cursor and scroll position untouched.
    local view = vim.fn.winsaveview()
    nvim_command("keeppatterns %s/\\($\\n\\s*\\)\\+\\%$//e")
    nvim_command("keeppatterns %s/\\s\\+$//e")
    vim.fn.winrestview(view)
  end,
})

autocmd({ "FileType" }, {
  group = augroup("ruby-settings", { clear = true }),
  pattern = "ruby",
  callback = function()
    vim.cmd.setlocal("indentkeys-=.")

    local pairs = require("mini.pairs")
    pairs.map_buf(0, "i", "|", { action = "closeopen", pair = "||" })
  end
})

autocmd({ "FileType" }, {
  group = augroup("gdscript-settings", { clear = true }),
  pattern = "gdscript",
  callback = function()
    vim.cmd.setlocal("indentkeys-=.")
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

local oil_inited = false

autocmd({ "FileType" }, {
  group = augroup("oil", { clear = true }),
  pattern = "oil",
  callback = function()
    local function copy_file_path()
      local oil = require('oil')
      local nvim_cwd = vim.fn.getcwd()
      local oil_cwd = oil.get_current_dir()
      local entry = oil.get_cursor_entry()

      if not entry then
        print("No file selected.")
        return
      end

      local full_path = oil_cwd .. entry.name
      local relative_path = full_path:gsub("^" .. vim.pesc(nvim_cwd .. "/"), "")
      vim.fn.setreg('+', relative_path)

      print("Copied path: " .. relative_path)
    end

    noremap("n", "Y", copy_file_path, { buffer = true })

    if not oil_inited then
      oil_inited = true
      require("oil.actions").tcd.callback()
    end
  end
})

autocmd({ "LspAttach" }, {
  group = augroup("lsp-attach", { clear = true }),
  callback = function(args)
    local lsp_opts = { silent = true, buffer = args.buf }

    noremap("n", "grr", function()
      require("telescope.builtin").lsp_references()
    end, lsp_opts)

    noremap("n", "gri", function()
      require("telescope.builtin").lsp_implementations()
    end, lsp_opts)

    noremap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, lsp_opts)


    local diagnostic_opts = { silent = true }
    noremap("n", "<leader>e", vim.diagnostic.open_float, diagnostic_opts)
    noremap("n", "<leader>ld", function()
      require("telescope.builtin").diagnostics()
    end, diagnostic_opts)
    noremap("n", "<leader>d", function()
      require("telescope.builtin").diagnostics({ bufnr = args.buf })
    end, diagnostic_opts)

    noremap("n", "<leader>q", vim.diagnostic.setloclist, diagnostic_opts)
  end,
})

autocmd({ "FileType" }, {
  group = augroup("treesitter", { clear = true }),
  pattern = { "ruby", "javascript", "javascriptreact", "typescript", "json", "yaml", "elixir", "heex", "zig", "gdscript" },
  callback = function()
    vim.treesitter.start()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
