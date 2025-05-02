---@type LazySpec
return {
  "vyfor/cord.nvim",
  build = ':Cord update',
  event = "VeryLazy",
  opts = {
    idle = {
      enabled = false,
    },
  },
}
