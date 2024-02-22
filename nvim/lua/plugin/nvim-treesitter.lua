return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "VeryLazy" },
  dependencies = {
    --nvim-cmp
    {"ray-x/cmp-treesitter"},
    -- textobj
    --{ "RRethy/nvim-treesitter-textsubjects" },
    -- UI
    { "haringsrob/nvim_context_vt" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      --[[
      textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-outer',
          ['i;'] = 'textsubjects-container-inner',
          ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
        },
      },
      ]]
    })
  end,
}
