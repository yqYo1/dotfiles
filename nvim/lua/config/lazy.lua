require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
  vim.env.NVIM_COLORSCHEME = "catppuccin"
end

-- load plugins
lazy.setup({
  spec = {
    { import = "plugin" },
    { import = "cli" },
  },
  defaults = { lazy = true },
  install = {
    missing = true,
    colorscheme = { "catppuccin" },
  },
  checker = { enabled = false },
  concurrency = 64,
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "netrw",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "zipPlugin",
        "zip",
      },
    },
  },
  rocks = {
    enabled = false,
  },
})
