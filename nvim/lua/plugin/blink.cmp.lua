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
    "fang2hou/blink-copilot",
    "L3MON4D3/LuaSnip"
  },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    completion = {
      menu = { border = 'single'},
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = { border = 'single' }
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = {
          "lazydev",
          "lsp",
          "snippets",
          "copilot",
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
          score_offset = 100,
          async = true,
        }
      }
    }
  },
  opts_extend = { "sources.default" }
}
