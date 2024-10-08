return {
  "nvimtools/none-ls.nvim",
  event = { "VeryLazy" },
  cond = not is_vscode(),
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        diagnostics_format = "#{m} (#{s}: #{c})",
        null_ls.builtins.formatting.stylua,
      },
    })
  end,
}
