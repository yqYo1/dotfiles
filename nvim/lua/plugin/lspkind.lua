---@type LazySpec
return {
  "onsails/lspkind.nvim",
  -- config = function(_, opts)
  --   require("lspkind").init(opts)
  -- end,
  opts = {
    preset = "codicons",
    symbol_map = {
      calc = " 󰃬 ",
      Class = "󰠱",
      Color = "󰏘",
      Constant = "󰏿",
      Constructor = " ",
      Copilot = "",
      Enum = " ",
      EnumMember = " ",
      Event = "",
      Field = "󰜢",
      File = "󰈙 ",
      Folder = "󰉋",
      Function = "󰊕",
      Text = "󰉿 ",
      Method = "󰆧",
      Variable = " ",
      Interface = " ",
      Module = " ",
      Property = "󰜢",
      Unit = " ",
      Value = "󰎠 ",
      Keyword = " ",
      Snippet = " ",
      Reference = "󰈇",
      Struct = "󰙅",
      Operator = "󰆕",
      TypeParameter = " ",
    },
  },
}
