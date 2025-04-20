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
    keymap = {
      preset = "super-tab"
    },
    completion = {
      menu = {
        border = 'single',
        draw = {
          columns = {
            {"label", "label_description", gap = 1 },
            { "kind_icon", gap = 1,  "kind" }
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = { border = 'single' }
      },
    },
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
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept_and_enter", "fallback"}
      },
      completion = {
        ghost_text = { enabled = true },
        menu = {
          auto_show = true ,
        },
      },
    },
  },
  opts_extend = { "sources.default" }
}
