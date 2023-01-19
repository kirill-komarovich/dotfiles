local mason_config = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local handlers = require("kirillkomaroich.lsp.handlers")

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

for _, server in ipairs(mason_config.get_installed_servers()) do
  local local_opts = {}

  local settings_path = string.format("kirillkomaroich.lsp.settings.%s", server)
  local status_ok, server_opts = pcall(require, settings_path)

  if status_ok then
    local_opts = vim.tbl_deep_extend("force", server_opts, opts)
  else
    local_opts = vim.tbl_deep_extend("force", local_opts, opts)
  end

  lspconfig[server].setup(local_opts)
end
