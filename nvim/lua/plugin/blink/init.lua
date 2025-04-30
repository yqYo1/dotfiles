local is_vscode = require("core.utils").is_vscode

local function has_cmp()
  return require("core.plugin").has("nvim-cmp")
end

---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "*",
  cond = function()
    return not (has_cmp() or is_vscode())
  end,
  event = { "InsertEnter", "CmdLineEnter" },
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
    "fang2hou/blink-copilot",
    "L3MON4D3/LuaSnip"
  },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = require("plugin.blink.keymap").insert,
    completion = require("plugin.blink.completion").insert,
    fuzzy = require("plugin.blink.fuzzy"),
    snippets = { preset = "luasnip" },
    sources = require("plugin.blink.sources").insert,
    signature = { enabled = true },
    cmdline = {
      keymap = require("plugin.blink.keymap").cmdline,
      completion = require("plugin.blink.completion").cmdline,
    },
  },
  opts_extend = { "sources.default" }
}
