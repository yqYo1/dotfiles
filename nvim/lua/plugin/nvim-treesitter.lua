local function has_cmp()
  return require("core.plugin").has("nvim-cmp")
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "VeryLazy" },
  dependencies = {
    {
      "ray-x/cmp-treesitter",
      cond = function()
        return has_cmp() and not is_vscode()
      end,
    },
    { "HiPhish/rainbow-delimiters.nvim" },
    { "m-demare/hlargs.nvim" },
    { "nvim-treesitter/nvim-treesitter-context" },
    { "haringsrob/nvim_context_vt" },
  },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
