---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  opts = {
    opts = {
      language = "Japanese",
    },
    display = {
      chat = {
        show_header_separator = true,
      }
    },
    strategies = {
      chat = {
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
        }
      }
    }
  },
}
