---@type LazySpec
return {
    "ravitemer/mcphub.nvim",
    -- dependencies = {
    --     "nvim-lua/plenary.nvim",
    -- },
    -- TODO: use cli dir local plugin
    build = "bun install -g mcp-hub@latest",
    ---@module "mcphub"
    ---@type MCPHub.Config
      ---@diagnostic disable-next-line:missing-fields
    opts = {
      cmd = "mcp-hub"
    }
}
