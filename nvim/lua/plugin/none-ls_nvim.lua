return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile", "VeryLazy"},
  dependencies = {"nvim-lua/plenary.nvim"},
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
      },
    })
  end
}
