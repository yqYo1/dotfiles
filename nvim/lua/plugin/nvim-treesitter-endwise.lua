---@type LazySpec
return {
  "RRethy/nvim-treesitter-endwise",
  event = "InsertEnter",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      endwise = {
        enable = true,
      },
    })
  end
}
