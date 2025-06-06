return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "VeryLazy" },
  config = function()
    local configs = require("nvim-treesitter.configs")
    ---@diagnostic disable-next-line: missing-fields
    configs.setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
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
      ignore_install = {},
    })
  end,
}
