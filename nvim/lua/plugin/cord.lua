---@type LazySpec
return {
  "vyfor/cord.nvim",
  build = ':Cord update',
  event = "VeryLazy",
  ---@module "cord"
  ---@type CordConfig
  ---@diagnostic disable-next-line:missing-fields
  opts = {
    display = {
      flavor = "accent",
    },
    idle = {
      enabled = false,
    },
  },
}
