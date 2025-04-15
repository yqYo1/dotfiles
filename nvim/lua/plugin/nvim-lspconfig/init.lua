local is_vscode = require("core.utils").is_vscode

return {
  {
    import = "plugin.nvim-lspconfig.servers",
  },
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    event = { "VeryLazy" },
    cond = not is_vscode(),
    dependencies = {
      -- "node_servers",
      -- "python_tools",
      -- "b0o/schemastore.nvim",
      --"lspcontainers/lspcontainers.nvim",
      -- "ray-x/lsp_signature.nvim",
    },
    init = function()
      require("core.plugin").on_attach(function(client, bufnr)
        local exclude_ft = { "oil" }
        local ft = vim.bo.filetype
        if vim.tbl_contains(exclude_ft, ft) then
          return
        end

        local on_attach = require("plugin.nvim-lspconfig.on_attach")
        on_attach(client, bufnr)

        vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      end)
    end,
  },
}
