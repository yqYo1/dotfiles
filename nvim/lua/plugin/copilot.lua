local is_vscode = require("core.utils").is_vscode

---@type LazySpec
return {
  "zbirenbaum/copilot.lua",
  cond = not is_vscode(),
  event = { "InsertEnter", "VeryLazy" },
  ---@module "copilot"
  ---@type CopilotConfig
  ---@diagnostic disable missing-fields
  opts = {
    suggestion = { enabled = false },
    panel = {enabled = false},
    filetypes = {
      oil = false,
    },
  },
}
