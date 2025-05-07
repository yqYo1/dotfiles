---@type LazySpec
return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    {"nvim-lua/plenary.nvim"},
  },
  event = "LspAttach",
  opts = {},
  keys = {
    {
      "gra",
      function()
        require("tiny-code-action").code_action({})
      end,
      mode = { "n", "v" },
      desc = "Code Actions",
    },
  },
}
