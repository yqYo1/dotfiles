local function diagnostic_formatter(diagnostic)
  return string.format("%s (%s:%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

---@type LazySpec
return {
  "lsp-diagnostics",
  virtual = true,
  event = { "LspAttach" },
  config = function()
    local signs = {
      Error = " ",
      Warn = " ",
      Info = " ",
      Hint = " ",
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local formatter = require("lsp.diagnostic.formatter")
    vim.diagnostic.config({
      underline = true,
      signs = true,
      update_in_insert = true,
      severity_sort = true,
      virtual_text = false,
      virtual_lines = {
        format = function(diagnostic)
          return formatter.format_diagnostic_message(diagnostic)
        end,
      },
      float = { sformat = diagnostic_formatter },
    })
  end,
}
