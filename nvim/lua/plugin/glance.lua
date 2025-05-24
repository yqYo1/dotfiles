---@type LazySpec
return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  keys = {
    {
      "grr",
      "<CMD>Glance references<CR>",
      mode = { "n" },
      desc = "references from the LSP",
    },
    {
      "grd",
      "<CMD>Glance definitions<CR>",
      mode = { "n" },
      desc = "definitions from the LSP",
    },
    {
      "grt",
      "<CMD>Glance type_definitions<CR>",
      mode = { "n" },
      desc = "type definitions from the LSP",
    },
    {
      "gri",
      "<CMD>Glance implementations<CR>",
      mode = { "n" },
      desc = "implementations from the LSP",
    },
  },
  opts = {},
}
