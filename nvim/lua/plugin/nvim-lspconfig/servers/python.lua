local utils = require("core.utils")
local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup

local pythonName = "python3"

if is_windows() then
  pythonName = "python"
end

local function python_lsp_init(_, config)
  local lspconfig = require("lspconfig")
  config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
      and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", pythonName)
    or utils.find_cmd(pythonName, ".venv/bin", config.root_dir)
end

return {
  {
    name = "pylyzer",
    dir = "",
    dependencies = {
      "neovim/nvim-lspconfig",
      "python_tools",
    },
    ft = function(spec)
      return lsp_utils.get_default_filetypes(spec.name)
    end,
    opts = function()
      return {
        before_init = python_lsp_init,
        settings = {
          python = {
            checkOnType = false,
            diagnostics = true,
            inlayHints = true,
            smartCompletion = true,
          },
        },
      }
    end,
    config = function(spec, opts)
      setup(spec.name, opts)
    end,
  },
  {
    name = "ruff_lsp",
    dir = "",
    dependencies = {
      "neovim/nvim-lspconfig",
      "python_tools",
    },
    ft = function(spec)
      return lsp_utils.get_default_filetypes(spec.name)
    end,
    opts = function()
      return {
        before_init = python_lsp_init,
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          },
        },
      }
    end,
    config = function(spec, opts)
      setup(spec.name, opts)
    end,
  },
}
