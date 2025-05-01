---@type LazySpec
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    preset = "modern",
    delay = 400,
    layout = {
      -- width = { min = 20, max = 50 },
      haight = { mini = 3, max = 15 },
      spacing = 2,
    },
    sort = { "alphanum", "order"},
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end
}
