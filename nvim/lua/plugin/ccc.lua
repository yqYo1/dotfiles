local is_vscode = require("core.utils").is_vscode

---@type LazySpec
return {
  "uga-rosa/ccc.nvim",
  cond = not is_vscode(),
  event = { "VeryLazy" },
  config = function()
    local ccc = require("ccc")
    ccc.setup({
      pickers = {
        ccc.picker.ansi_escape(),
        ccc.picker.hex,
        ccc.picker.hex_long,
        ccc.picker.hex_short,
        ccc.picker.css_rgb,
        ccc.picker.css_hsl,
        ccc.picker.css_hwb,
        ccc.picker.css_lab,
        ccc.picker.css_lch,
        ccc.picker.css_oklab,
        ccc.picker.css_oklch,
        -- ccc.picker.css_name,
      },
    })
  end,
}
