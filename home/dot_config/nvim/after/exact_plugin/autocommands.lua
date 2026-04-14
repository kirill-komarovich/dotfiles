local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local nvim_command = vim.api.nvim_command
local noremap = require("kirillkomarovich.remap").noremap

-- Trim Whitespaces at the end of line
-- Trim blank lines at the end of file
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("general-settings", { clear = true }),
  callback = function()
    nvim_command("%s/\\($\\n\\s*\\)\\+\\%$//e")
    nvim_command("%s/\\s\\+$//e")
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
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
