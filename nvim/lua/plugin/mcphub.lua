---@type LazySpec
return {
    "ravitemer/mcphub.nvim",
    -- dependencies = {
    --     "nvim-lua/plenary.nvim",
    -- },
    build = "bun install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
    opts = {}
}
