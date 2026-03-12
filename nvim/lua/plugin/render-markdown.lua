local is_vscode = require("core.utils").is_vscode

---@type LazySpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { "markdown", "markdown.mdx", "Avante", "codecompanion" },
  cond = not is_vscode(),
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
