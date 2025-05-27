---@type LazySpec
return {
  "atusy/aibou.nvim",
  keys = {
    {
      "<leader>ai",
      function()
        require("aibou.codecompanion").start({
          codecompanion = {
            chat_args ={
              adapter = "copilot",
            }
          }
        })
      end,
      mode = { "n" },
      desc = "Start aibou",
    }
  },
}
