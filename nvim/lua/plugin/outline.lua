---@type LazySpec
return {
  "hedyhli/outline.nvim",
  keys = {
    {
      "<leader>o",
      function()
        require("outline").toggle()
      end,
      desc = "Toggle outline"
    },
  },
  opts = {
    outline_window = {
      position = "left",
      show_numbers = true,
      focus_on_open = false,
    },
  },
}
