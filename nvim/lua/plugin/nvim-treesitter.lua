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
    { "nvim-treesitter/nvim-treesitter-context" },
    { "haringsrob/nvim_context_vt" },
  },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "python" },
      },
    })
  end,
}
