---@type LazySpec
return {
  'echasnovski/mini.indentscope',
  version = '*',
  event = 'VeryLazy',
  opts = {},
  config = function(_, opts)
    require('mini.indentscope').setup(opts)
    vim.g.miniindentscope_disable = true
  end,
}
