---@type LazySpec
return {
  "gorbit99/codewindow.nvim",
  keys = {
    {
      "<leader>mm",
      function()
        require("codewindow").toggle_minimap()
      end,
      desc = "Toggle code window",
    },
  },
  opts = {},
}
