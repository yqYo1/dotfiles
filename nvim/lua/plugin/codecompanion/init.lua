---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "ravitemer/codecompanion-history.nvim",
    "franco-ruggeri/codecompanion-spinner.nvim",
    "jinzhongjia/codecompanion-gitcommit.nvim",
  },
  event = "VeryLazy",
  opts = {
    opts = {
      language = "Japanese",
    },
    display = {
      action_palette = {
        provider = "snacks",
      },
      chat = {
        show_header_separator = true,
      },
    },
    adapters = {
      http = {
        copilot = function()
          return require("codecompanion.adapters.http").extend("copilot", {
            schema = {
              model = {
                -- default = "gpt-5-mini",
                default = "gpt-4.1",
              },
            },
          })
        end,
      },
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
              chat:submit()
              chat:add_buf_message({ role = "llm", content = "" })
            end,
            index = 1,
            description = "Send",
          },
        },
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
    },
    extensions = {
      spinner = {},
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          -- MCP Tools
          make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
          show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
          add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          show_result_in_chat = true, -- Show tool results directly in chat buffer
          format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
          -- MCP Resources
          make_vars = true, -- Convert MCP resources to #variables for prompts
          -- MCP Prompts
          make_slash_commands = true, -- Add MCP prompts as /slash commands
        },
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
        },
      },
      gitcommit = {
        callback = "codecompanion._extensions.gitcommit",
        opts = {
          -- Basic configuration
          languages = { "English", "Japanese" }, -- Supported languages

          -- File filtering (optional)
          exclude_files = {
            "*.pb.go",
            "*.min.js",
            "*.min.css",
            "package-lock.json",
            "yarn.lock",
            "*.log",
            "dist/*",
            "build/*",
            ".next/*",
            "node_modules/*",
            "vendor/*",
          },

          -- Buffer integration
          buffer = {
            enabled = true, -- Enable gitcommit buffer keymaps
            auto_generate = true, -- Auto-generate on buffer enter
            auto_generate_delay = 200, -- Auto-generation delay (ms)
            skip_auto_generate_on_amend = true, -- Skip auto-generation during git commit --amend
          },

          -- Feature toggles
          add_slash_command = true, -- Add /gitcommit slash command
          add_git_tool = true, -- Add @{git_read} and @{git_edit} tools
          enable_git_read = true, -- Enable read-only Git operations
          enable_git_edit = true, -- Enable write-access Git operations
          enable_git_bot = true, -- Enable @{git_bot} tool group (requires both read/write enabled)
          add_git_commands = true, -- Add :CodeCompanionGitCommit commands
          git_tool_auto_submit_errors = false, -- Auto-submit errors to LLM
          git_tool_auto_submit_success = true, -- Auto-submit success to LLM
          gitcommit_select_count = 100, -- Number of commits shown in /gitcommit

          -- Commit history context (optional)
          use_commit_history = true, -- Enable commit history context
          commit_history_count = 10, -- Number of recent commits for context
        },
      },
    },
  },
}
