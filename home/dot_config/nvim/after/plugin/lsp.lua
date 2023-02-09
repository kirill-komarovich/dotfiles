local mason_config = require("mason-lspconfig")
local handlers = require("kirillkomaroich.lsp.handlers")

handlers.setup()
require("mason").setup()

mason_config.setup {
    ensure_installed = {
    "solargraph",
    "jsonls",
    "yamlls",
    "dockerls",
    "elixirls",
    "tailwindcss",
    "tsserver",
    "sumneko_lua",
  },
}

local opts = {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
}

mason_config.setup_handlers({
  function (server_name)
    local local_opts = {}

    local settings_path = string.format("kirillkomaroich.lsp.settings.%s", server_name)
    local status_ok, server_opts = pcall(require, settings_path)

    if status_ok then
      local_opts = vim.tbl_deep_extend("force", server_opts, opts)
    else
      local_opts = vim.tbl_deep_extend("force", local_opts, opts)
    end

    require("lspconfig")[server_name].setup(local_opts)
  end,
})
