---@type LazySpec
return {
  "lsp-config",
  virtual = true,
  event = { "LspAttach" },
  config = function()
    vim.diagnostic.config({
      severity_sort = true,
      virtual_lines = {
        format = function(diagnostic)
          return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
        end,
      },
    })
  end,
}
