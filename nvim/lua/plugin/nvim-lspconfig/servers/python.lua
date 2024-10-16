local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
local utils = require("core.utils")
local lspconfig = require("lspconfig")
local python_lsp_init = function(_, config)
  config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
      and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    or utils.find_cmd("python3", ".venv/bin", config.root_dir)
end
local dir_base
if is_windows() then
  dir_base = vim.env.TEMP .. "\\nvim\\lsp-"
else
  dir_base = vim.env.TMPDIR .. "/nvim/lsp-"
end

return {
  {
    name = "basedpyright",
    dir = dir_base .. "basedpyright",
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
                reportIgnoreCommentWithoutRule = false,
                reportUnusedCallResult = false,
                reportUnusedVariable = false,
                reportUnknownMemberType = false,
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
    dir = dir_base .. "ruff_lsp",
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
        before_init = python_lsp_init,
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
