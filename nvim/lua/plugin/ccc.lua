return {
  "uga-rosa/ccc.nvim",
  cond = not is_vscode(),
  event = { "VeryLazy" },
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
}
