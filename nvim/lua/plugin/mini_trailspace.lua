---@type LazySpec
return {
  'echasnovski/mini.trailspace',
  version = '*',
  event = "VeryLazy",
  init = function()
    vim.api.nvim_create_user_command("TrimSpace", function()
      require('mini.trailspace').trim()
    end,{})
    vim.api.nvim_create_user_command("TrimLine", function()
      require('mini.trailspace').trim_last_lines()
    end,{})
  end,
  opgx = {},
}
