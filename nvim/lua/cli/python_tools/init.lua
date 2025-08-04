---@type LazySpec
return {
  name = "python_tools",
  dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
  build = "rye sync",
  config = function(spec)
    local Path = require("plenary.path")
    local BIN_DIR = Path:new(spec.dir, ".venv", "bin"):absolute()
    vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
  end,
}
