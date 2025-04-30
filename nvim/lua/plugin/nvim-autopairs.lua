
local function has_cmp()
  return require("core.plugin").has("nvim-cmp")
end

---@type LazySpec
return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  -- cond = function()
  --   return has_cmp()
  -- end,
  cond = has_cmp(),
  opts = {},
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    if has_cmp() then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end
  end
}
