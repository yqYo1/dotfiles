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
    -- highlights = {
    --   enabled =true,
    --   groups = {
    --     'BlinkPairsOrange',
    --     'BlinkPairsPurple',
    --     'BlinkPairsBlue',
    --   },
    --   priority = 3000,
    --   ns = vim.api.nvim_create_namespace('blink.pairs'),
    -- }
  }
}
