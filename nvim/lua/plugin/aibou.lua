---@type LazySpec
return {
  "atusy/aibou.nvim",
  keys = {
    {
      "<leader>ai",
      function()
        require("aibou.codecompanion").start({
          codecompanion = {
            ---@diagnostic disable-next-line: missing-fields
            chat_args = {
              http = {
                adapter = "copilot",
              },
            },
          },
        })
      end,
      mode = { "n" },
      desc = "Start aibou",
    },
  },
}
