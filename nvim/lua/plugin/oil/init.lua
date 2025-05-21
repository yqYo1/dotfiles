local is_vscode = require("core.utils").is_vscode
local has_Snacks = require("core.plugin").has("snacks")
local tb = require("core.utils").tb

---@type LazySpec
return {
  {
    "stevearc/oil.nvim",
    -- dependencies = {
    --   "nvim-tree/nvim-web-devicons",
    -- },
    cond = not is_vscode(),
    opts = function()
      return {
        view_options = {
          show_hidden = true,
        },
        win_options = {
          signcolumn = "yes:2",
        },
      }
    end,
    config = function(_, opts)
      require("oil").setup(opts)
    end,
    init = function()
      local openWithOil = function()
        local path = vim.fn.expand("%:p")

        if string.match(path, "oil://") then return end

        if not tb(vim.fn.isdirectory(path)) then return end

        vim.cmd.Oil(path)
      end
      vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = openWithOil, nested = true })
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = openWithOil })
      if has_Snacks then
        vim.api.nvim_create_autocmd("User", {
          pattern = "OilActionsPost",
          callback = function(event)
            if event.data.actions.type == "move" then
              require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
            end
          end,
        })
      end
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    event = "VeryLazy",
    cmd = { "Oil" },
    dependencies = {
      "stevearc/oil.nvim",
    },
    cond = not is_vscode(),
    opt = {},
  },
}
