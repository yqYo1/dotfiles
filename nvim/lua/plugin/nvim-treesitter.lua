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
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "powershell",
        "printf",
        "query",
        "regex",
        "rust",
        "ssh_config",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "python" },
      },
    })
  end,
}
