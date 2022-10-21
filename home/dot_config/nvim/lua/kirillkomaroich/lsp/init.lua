local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  print("LSP config not found")
	return
end

require("kirillkomaroich.lsp.lsp-installer")
require("kirillkomaroich.lsp.handlers").setup()
