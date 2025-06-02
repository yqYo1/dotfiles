local on_attach = function(client, bufnr)
  require("plugin.nvim-lspconfig.on_attach.format").on_attach(client, bufnr)
  require("plugin.nvim-lspconfig.on_attach.signature").on_attach(client, bufnr)
end

return on_attach
