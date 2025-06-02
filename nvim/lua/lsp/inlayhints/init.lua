---@type LazySpec
return {
  "lsp-inlayhints",
  virtual = true,
  event = { "LspAttach" },
  config = function()
    require("lsp.inlayhints.inlayhints").setup()
  end
}
