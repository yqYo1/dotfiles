---@type LazySpec
return {
  "ysmb-wtsg/in-and-out.nvim",
  -- event = "InsertEnter",
  keys = {
    {
      "<C-o>",
      function()
        require("in-and-out").in_and_out()
      end,
      mode = "i",
      desc = "in-and-out"
    },
  },
  opts = {},
}
