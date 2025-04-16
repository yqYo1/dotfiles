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
          }
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
        menu = {
          auto_show = true ,
        },
      },
      sources = {
        providers = {
          cmdline = {
          min_keyword_length = function(ctx)
            if ctx.mode == "cmdline" and ctx.line:find("^%l+$") ~= nil then
              return 3
            else
              return 0
            end
          end,
          }
        }
      }
    },
  },
  opts_extend = { "sources.default" }
}
