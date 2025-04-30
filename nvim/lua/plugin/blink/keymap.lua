local M = {}
---@module "blink.cmp"
---@type blink.cmp.KeymapConfig
M.insert = {
  preset = "super-tab"
}
---@type blink.cmp.KeymapConfig
M.cmdline = {
  preset = "super-tab",
  ["<CR>"] = { "accept_and_enter", "fallback"}
}
return M
