---@type LazySpec
return {
  "vyfor/cord.nvim",
  build = "./build || .\\build",
  event = "VeryLazy",
  opts = {
    idle = {
      enable = false,
    },
  },
}