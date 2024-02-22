
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile", "VeryLazy" },
  dependencies = {
    --"node_servers",
    "python_tools",
    "cli",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  config = function()
    --local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    --lua
    lspconfig.lua_ls.setup({
      settings = {
        lua = {
          diagnostics = {
            global = {"vim"},
          },
        },
      },
    })
    --python
    lspconfig.pylsp.setup({
      settings = {
        pylsp = {
          plugins = {
            ruff = {
              enabled = true,
            }
          }
        }
      }
    })
  end,
}
