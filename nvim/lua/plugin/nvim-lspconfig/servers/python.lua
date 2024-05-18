local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
--[[
--[[
]]
local utils = require("core.utils")
local lspconfig = require("lspconfig")
local python_lsp_init = function(_, config)
  config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
      and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    or utils.find_cmd("python3", ".venv/bin", config.root_dir)
  --or utils.find_cmd("python3", "venv/bin", config.root_dir)
end
--]]

return {
  {
    name = "basedpyright",
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
          basedpyright = {
            disableOrganizeImports = false,
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = false,
              --ignore = { "*" },
              --diagnosticMode = "workspace",
              diagnosticMode = "openFilesOnly",
              diagnosticSeverityOverrides = {
                -- https://detachhead.github.io/basedpyright/#/configuration?id=based-options
                reportUnusedImport = false,
                reportMissingTypeStubs = false,
                reportImplicitRelativeImport = false,
                reportUnusedCallResult = false,
                reportAny = "information",
              },
              typeCheckingMode = "all",
              --typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
            },
          },
          python = {},
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
    --enabled = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "python_tools",
    },
    ft = function(spec)
      return lsp_utils.get_default_filetypes(spec.name)
    end,
    config = function(spec, _)
      setup(spec.name, {
        --before_init = python_lsp_init,
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          },
        },
        python = {},
      })
    end,
  },
}
