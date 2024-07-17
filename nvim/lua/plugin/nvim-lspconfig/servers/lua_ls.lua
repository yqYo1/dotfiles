local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config
local dir_name
if is_windows() then
  dir_name = vim.env.TEMP .. "\\nvim\\lsp-luals"
else
  dir_name = vim.env.TMPDIR .. "/nvim/lsp-luals"
end

return {
  name = "lua_ls",
  dir = dir_name,
  dependencies = { "neovim/nvim-lspconfig" },
  ft = function(spec)
    return lsp_utils.get_default_filetypes(spec.name)
  end,
  opts = function()
    return {
      on_attach = format_config(false),
      flags = {
        debounce_text_changes = 150,
      },
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
        },
      },
    }
  end,
  config = function(spec, opts)
    setup(spec.name, opts)
  end,
}
