local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end
local lspconfig = require("lspconfig")

lsp_installer.setup({
  ensure_installed = {
    "solargraph",
    "jsonls",
    "yamlls",
    "dockerls",
    "elixirls",
    "tailwindcss",
    "tsserver",
  },
})

local opts = {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local local_opts = {}

	local settings_path = string.format("user.lsp.settings.%s", server.name)
	local status_ok, server_opts = pcall(require, settings_path)
  if status_ok then
	  local_opts = vim.tbl_deep_extend("force", server_opts, opts)
  else
    local_opts = vim.tbl_deep_extend("force", local_opts, opts)
	end

  lspconfig[server.name].setup(local_opts)
end
