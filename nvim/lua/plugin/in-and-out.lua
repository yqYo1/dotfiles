---@type LazySpec
return {
  "ysmb-wtsg/in-and-out.nvim",
  --   enabled = true,
  event = "InsertEnter",
  -- keys = {
  --   {
  --     "<C-CR>",
  --     function()
  --       require("in-and-out").in_and_out()
  --     end,
  --     mode = "i"
  --   },
  -- },
  opts = {},
  config = function(_, opts)
    require("in-and-out").setup(opts)
    vim.keymap.set("i", "<C-CR>", function()
      require("in-and-out").in_and_out()
    end)
  end,
}
