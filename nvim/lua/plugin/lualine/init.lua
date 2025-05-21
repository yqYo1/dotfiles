---@type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "AndreM222/copilot-lualine",
    "pnx/lualine-lsp-status",
  },
  event = { "VeryLazy" },
  opts = function()
    return {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_c = {
          "filename",
          "lsp-status",
        },
        lualine_x = {
          require("plugin.lualine.components.codecompanion"),
        },
        lualine_y = {
          {
            "copilot",
            show_colors = true,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_z = {
          "location",
          "progress",
        },
        -- lualine_y = { "progress" },
        -- lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        -- lualine_x = { "location" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end,
}
