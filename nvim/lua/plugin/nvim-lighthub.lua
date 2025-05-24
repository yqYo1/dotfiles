---@type LazySpec
return {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
  ---@module "nvim-lightbulb",
  ---@type nvim-lightbulb.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    sign = { enabled = false },
    number = { enabled = true },
  },
}
