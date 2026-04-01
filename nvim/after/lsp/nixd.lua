local lsp_utils = require("core.lsp-utils")
local format_config = lsp_utils.format_config

---@type vim.lsp.Config
return {
  on_attach = format_config(false),
}
