local M = {}

---@module "blink.cmp"
---@type blink.cmp.CompletionConfigPartial
M.insert = {
  ghost_text = { enabled = true },
  list = {
    selection = {
      preselect = true,
      auto_insert = false
    }
  },
  menu = {
    auto_show = true,
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
}
---@type blink.cmp.ModeCompletionConfig
M.cmdline = {
  ghost_text = { enabled = true },
  list = {
    selection = {
      preselect = true,
      auto_insert = false,
    }
  },
  menu = {
    auto_show = true,
  }
}

return M
