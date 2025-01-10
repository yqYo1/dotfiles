---@type LazySpec
return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local has_cmp = require("core.plugin").has("nvim-cmp")
      if has_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
        )
      end
    end
}
