local install_path = require("mason-core.package").get_install_path({})

return {
  cmd = { vim.fn.resolve(install_path .. "/" .. "elixir-ls/language_server.sh") }
}
