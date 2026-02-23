---@type LazySpec
return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy",
  ---@module "cord"
  ---@type CordConfig
  ---@diagnostic disable-next-line:missing-fields
  opts = {
    display = {
      theme = "catppuccin",
      flavor = "accent",
    },
    idle = {
      enabled = false,
    },
    text = {
      workspace = "",
      editing = "Editing",
      viewing = "Viewing",
      file_browser = "Browsing files",
    },
  },
}
