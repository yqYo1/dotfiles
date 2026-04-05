local lsp_utils = require("core.lsp-utils")
local format_config = lsp_utils.format_config

---@type vim.lsp.Config
return {
  before_init = function(params, _)
    local text_document = params.capabilities and params.capabilities.textDocument
    if text_document then text_document.semanticTokens = nil end
  end,
  on_attach = format_config(false),
  workspace_required = true,
}
