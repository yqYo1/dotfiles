---@type LazySpec
return {
  "zbirenbaum/copilot.lua",
  cond = not is_vscode(),
  event = { "InsertEnter", "VeryLazy" },
  opts = {
    filetypes = {
      oil = false,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}
