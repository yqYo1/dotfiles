return {
  name = "node_servers",
  dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
  enabled = false,
  --dependencies = { "nvim-lua/plenary.nvim" },
  build = "bun update -g",
}
