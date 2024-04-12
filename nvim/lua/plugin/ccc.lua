return {
  "uga-rosa/ccc.nvim",
  cond = not is_vscode(),
  event = { "BufReadPost" },
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
}
