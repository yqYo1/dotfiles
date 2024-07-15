local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config
local dir_name
if is_windows() then
  dir_name = vim.env.TEMP .. "\\nvim\\lsp-clangd"
else
  dir_name = vim.env.TMPDIR .. "/lsp-clangd"
end

return {
  name = "clangd",
  dir = dir_name,
  dependencies = { "neovim/nvim-lspconfig" },
  ft = function(spec)
    return lsp_utils.get_default_filetypes(spec.name)
  end,
  opts = function()
    return {
      on_attach = format_config(false),
      settings = {},
    }
  end,
  config = function(spec, opts)
    setup(spec.name, opts)
  end,
}
