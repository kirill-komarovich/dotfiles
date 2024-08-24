local nnoremap = require("kirillkomarovich.remap").nnoremap

local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  local opts = { silent = true }

  nnoremap("<leader>e", vim.diagnostic.open_float, opts)
  nnoremap("<leader>ld", function()
    require("telescope.builtin").diagnostics()
  end, opts)
  nnoremap("<leader>d", function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
  end, opts)

  nnoremap("[d", vim.diagnostic.goto_prev, opts)
  nnoremap("]d", vim.diagnostic.goto_next, opts)
  nnoremap("<leader>q", vim.diagnostic.setloclist, opts)
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { silent = true, buffer = bufnr }
  nnoremap("gD", vim.lsp.buf.declaration, bufopts)
  nnoremap("gd", vim.lsp.buf.definition, bufopts)
  nnoremap("K", vim.lsp.buf.hover, bufopts)
  nnoremap("gi", vim.lsp.buf.implementation, bufopts)
  nnoremap("<C-k>", vim.lsp.buf.signature_help, bufopts)
  nnoremap("<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  nnoremap("<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  nnoremap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  nnoremap("<leader>D", vim.lsp.buf.type_definition, bufopts)
  nnoremap("<leader>r", vim.lsp.buf.rename, bufopts)
  nnoremap("<leader>a", vim.lsp.buf.code_action, bufopts)
  nnoremap("gr", function()
    require("telescope.builtin").lsp_references()
  end, bufopts)
  nnoremap("<leader>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

return M
