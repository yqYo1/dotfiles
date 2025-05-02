---@type LazySpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- event = 'VeryLazy',
  ft = { "markdown", "markdown.mdx", "Avante", "codecompanion" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "codecompanion" },
      completions = {
        blink = {
          enabled = true,
        },
      },
    },
}
