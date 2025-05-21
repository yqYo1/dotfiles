---@type LazySpec
return {
  "echasnovski/mini.indentscope",
  version = "*",
  keys = {
    { "ai", mode = { "x", "o" }, desc = "around indent" },
    { "ii", mode = { "x", "o" }, desc = "inner indent" },
    { "[i", mode = { "n", "x", "o" }, desc = "indent scope top" },
    { "]i", mode = { "n", "x", "o" }, desc = "indent scope bottom" },
  },
  opts = {},
  config = function(_, opts)
    -- disable draw indentscope
    -- due to use indent-blankline.nvim
    vim.g.miniindentscope_disable = true
    require("mini.indentscope").setup(opts)
  end,
}
