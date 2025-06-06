---@module "lazydev"

local is_vscode = require("core.utils").is_vscode

---@type LazySpec[]
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cond = not is_vscode(),
    ---@type lazydev.Config
    opts = {
      ---@type lazydev.Library.spec[]
      library = {
        -- See the configuration section for more details
        -- Or relative, which means they will be resolved from the plugin dir.
        "lazy.nvim",
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  { "Bilal2453/luvit-meta" },
  { "gonstoll/wezterm-types" },
}
