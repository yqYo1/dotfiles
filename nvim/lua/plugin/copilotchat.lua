---@type LazySpec
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "VeryLazy",
    enabled = false,
    -- dependencies = {
    --   { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    --   { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    -- },
    -- build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
  },
}
