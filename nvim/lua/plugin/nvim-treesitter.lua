local treesitter_path = vim.fs.joinpath(vim.fn.stdpath("data"), "/treesitter")
local parser_list = {
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
  "nix",
  "powershell",
  "printf",
  "python",
  "query",
  "regex",
  "rust",
  "ssh_config",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
    vim.cmd("TSUpdate")
    require("nvim-treesitter").install(parser_list)
  end,
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({
      parser_install_dir = treesitter_path,
    })

    vim.treesitter.language.register("bash", { "sh", "zsh" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parser_list,
      group = vim.api.nvim_create_augroup("nvim-treesitter_star", {}),
      callback = function(args)
        vim.treesitter.start(args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
