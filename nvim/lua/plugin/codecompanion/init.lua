---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "ravitemer/codecompanion-history.nvim"
  },
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
    adapters = {
      -- copilotアダプタを上書き
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gpt-4.1",
            },
          },
        })
      end,
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
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          -- MCP Tools 
          make_tools = true,              -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
          show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
          add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          show_result_in_chat = true,      -- Show tool results directly in chat buffer
          format_tool = nil,               -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
          -- MCP Resources
          make_vars = true,                -- Convert MCP resources to #variables for prompts
          -- MCP Prompts 
          make_slash_commands = true,      -- Add MCP prompts as /slash commands
        }
      },
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
          picker = "snacks",
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to active chat's adapter) 
            adapter = nil, -- e.g "copilot"
            ---Model for generating titles (defaults to active chat's model)
            model = nil, -- e.g "gpt-4o"
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,
        }
      },
    }
  },
  init = function()
    require("plugin.codecompanion.spinner"):init()
  end,
}
