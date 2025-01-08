---@type LazySpec
return {
  "ysmb-wtsg/in-and-out.nvim",
  keys = {
    {
      "<C-CR>",
      function()
        require("in-and-out").in_and_oot()
      end,
      mode = "i"
    },
  },
}
