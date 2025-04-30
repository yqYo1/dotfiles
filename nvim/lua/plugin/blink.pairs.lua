---@type LazySpec
return {
  "saghen/blink.pairs",
  version = "*",
  dependencies = {
    "saghen/blink.download",
  },
  event = "InsertEnter",
  ---@module "blink.pairs"
  ---@type blink.pairs.Config
  opts = {
    mappings = {
      enabled = true,
      pairs = {},
    },
  }
}
