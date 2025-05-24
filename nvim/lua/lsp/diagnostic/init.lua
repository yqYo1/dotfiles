---@type LazySpec
return {
  "lsp-config",
  virtual = true,
  event = { "LspAttach" },
  config = function()
    local formatter = require("lsp.diagnostic.formatter")
    vim.diagnostic.config({
      severity_sort = true,
      virtual_lines = {
        format = function(diagnostic)
          return formatter.format_diagnostic_message(diagnostic)
        end,
      },
    })
  end,
}
