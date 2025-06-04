---@type LazySpec
return {
  "pogyomo/submode.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    local submode = require("submode")
    submode.create("WindowMoveAndResize", {
      mode = "n",
      enter = "<C-w>",
      leave = { "q", "<ESC>" },
      default = function(register)
        register("h", "<C-w>h")
        register("j", "<C-w>j")
        register("k", "<C-w>k")
        register("l", "<C-w>l")
        register("<lt>", "<C-w><lt>")
        register(">", "<C-w>>")
        register("+", "<C-w>+")
        register("=", "<C-w>=")
        register("-", "<C-w>-")
        register("H", "<C-w><lt>")
        register("L", "<C-w>>")
        register("J", "<C-w>+")
        register("K", "<C-w>-")
      end,
    })
  end,
}
