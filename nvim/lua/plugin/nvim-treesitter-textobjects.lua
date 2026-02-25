---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "VeryLazy" },
  ---@type TSTextObjects.UserConfig
  opt = {
    select = {
      lookahead = true,
    },
  },
  keys = {
    {
      "af",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select outer part of a method/function definition",
    },
    {
      "if",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select inner part of a method/function definition",
    },
    {
      "ac",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select outer part of a class region",
    },
    {
      "ic",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select inner part of a class region",
    },
    {
      "as",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("@scope", "locals")
      end,
      mode = { "x", "o" },
      desc = "Select language scope",
    },
  },
}
