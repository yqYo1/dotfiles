---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  opts = {
    opts = {
      language = "Japanese",
    },
    display = {
      action_palette = {
        provider = "snacks"
      },
      chat = {
        show_header_separator = true,
      }
    },
    strategies = {
      chat = {
        adapter = "copilot",
        roles = {
          llm = function(adapter)
            local icon_char = ""
            if adapter.formatted_name == "Copilot" then
              icon_char = " "
            else
              icon_char = "󰚩 "
            end
            return icon_char .. " CodeCompanion (" .. adapter.formatted_name .. ")"
          end,
          user = "  Me",
        },
        keymaps = {
          send = {
            modes = { n = "<C-s>", i = "<C-s>" },
            callback = function(chat)
              vim.cmd("stopinsert")
              chat:add_buf_message({ role = "llm", content = "" })
              chat:submit()
            end,
            index = 1,
            description = "Send",
          }
        },
      }
    },
  },
  init = function()
    require("plugin.codecompanion.spinner"):init()
  end,
}
