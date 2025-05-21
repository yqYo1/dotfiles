---@type LazySpec
return {
  'echasnovski/mini.indentscope',
  version = '*',
  event = 'VeryLazy',
  opts = {},
  config = function(_, opts)
    require('mini.indentscope').setup(opts)
    -- disable draw indentscope
    -- due to use indent-blankline.nvim
    vim.g.miniindentscope_disable = true
  end,
}
