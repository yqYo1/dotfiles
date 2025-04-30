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
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = {
        "snippets",
        "copilot",
        "lazydev",
        "lsp",
        "path",
        "buffer"
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          async = true,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          async = true,
        },
      },
    },
    signature = { enabled = true },
    cmdline = {
      keymap = require("plugin.blink.keymap").cmdline,
      completion = require("plugin.blink.completion").cmdline,
    },
  },
  opts_extend = { "sources.default" }
}
