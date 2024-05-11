---@type LazySpec
return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  cmd = { "Oil" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "refractalize/oil-git-status.nvim",
  },
  init = function()
    local openWithOil = function()
      local path = vim.fn.expand("%:p")

      if string.match(path, "oil://") then
        return
      end

      if not tb(vim.fn.isdirectory(path)) then
        return
      end

      vim.cmd.Oil(path)
    end
    vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = openWithOil, nested = true })
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = openWithOil })
  end,
  opts = function()
    return {
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    }
  end,
  config = function(_, opts)
    require("oil").setup(opts)
    require("oil-git-status").setup()
  end,
}
