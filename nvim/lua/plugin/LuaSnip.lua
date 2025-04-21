-- local build_cmd = "make install_jsregexp"
-- if require("core.utils").is_windows() then
--   build_cmd = 'sh -c "' .. build_cmd .. 'CC=gcc.exe SHELL=C:/Program Files/Git/bin/sh.exe .SHELLFLAGS=-c"'
--   -- vim.print(build_cmd)
-- end

---@type LazySpec
return {
  "L3MON4D3/LuaSnip",
  version = "*",
  -- build = build_cmd,
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip").setup({})
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()
  end,
}
