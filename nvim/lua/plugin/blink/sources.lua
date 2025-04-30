local M = {}

---@module "blink.cmp"
---@type blink.cmp.SourceConfigPartial
M.insert = {
  default = {
    "snippets",
    "copilot",
    "lazydev",
    "lsp",
    "path",
    "buffer"
  },
  providers = {
    lazydev = {
      name = "LazyDev",
      module = "lazydev.integrations.blink",
      score_offset = 100,
      async = true,
    },
    copilot = {
      name = "copilot",
      module = "blink-copilot",
      async = true,
    },
  },
  min_keyword_length = function(ctx)
    if ctx.mode == "cmdline" and ctx.line:find("^%l+$") ~= nil then
      return 3
    end
    return 0
  end
}

return M
