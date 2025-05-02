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
            return "  CodeCompanion (" .. adapter.formatted_name .. ")"
          end,
          user = "  Me",
        }
      }
    }
  },
}
