local lsp_utils = require("core.lsp-utils")
local format_config = lsp_utils.format_config

---@type vim.lsp.Config
return {
  on_attach = format_config(false),
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        checkThirdParty = false,
      },
      diagnostics = {
        globals = { "vim" },
      },
      completion = {
        showWord = "Fallback",
        callSnippet = "Replace",
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = true,
      },
      semantic = {
        enable = false,
      },
    },
  },
}
