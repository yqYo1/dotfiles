return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = { "VeryLazy" },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = {
              query = "@function.outer",
              desc = "Select outer part of a method/function definition",
            },
            ["if"] = {
              query = "@function.inner",
              desc = "Select inner part of a method/function definition",
            },
            ["ac"] = {
              query = "@class.outer",
              desc = "Select outer part of a class region",
            },
            ["ic"] = {
              query = "@class.inner",
              desc = "Select inner part of a class region",
            },
            ["as"] = {
              query = "@scope",
              query_group = "locals",
              desc = "Select language scope",
            },
          },
          -- selection_modes = {
          --   ["@function.outer"] = "V", -- linewise
          --   ["@function.inner"] = "V",
          --   ["@class.outer"] = "<c-v>", -- blockwise
          --   ["@class.inner"] = "V",
          --   ["@scope"] = "V",
          -- },
        },
      },
    })
  end,
}
