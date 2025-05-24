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
          -- vim.print(formatter.format_diagnostic_message(diagnostic))
          -- return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
          return string.format(
            "[%s]%s (%s: %s)",
            formatter.format_diagnostic_message(diagnostic),
            diagnostic.message,
            diagnostic.source,
            diagnostic.code
          )
        end,
      },
    })
  end,
}
