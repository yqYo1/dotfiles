--[[
return {
  name = "python_tools",
  dir = "",
  opts = {
    tools = {
      "ruff",
      "ruff-lsp",
      "pylyzer",
      "basedpyright",
    },
  },
  config = function(_, opts)
    vim.schedule(function()
      vim.iter(opts.tools):map(_l("x: vim.system({ 'rye', 'install', '-f', x }, { text = true })"))
    end)
  end,
}
]]
return {
  name = "python_tools",
  dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
  dependencies = { "nvim-lua/plenary.nvim" },
  build = "rye sync",
  config = function(spec)
    local Path = require("plenary.path")

    local BIN_DIR = Path:new(spec.dir, ".venv", "bin"):absolute()

    vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
  end,
}
