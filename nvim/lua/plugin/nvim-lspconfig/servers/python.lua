local is_windows = require("core.utils").is_windows()
local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
local utils = require("core.utils")
local python_lsp_init = function(_, config)
  if is_windows then
    config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
        and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "Scripts", "python")
      or utils.find_cmd("python.exe", ".venv/Scripts", config.root_dir)
  else
    config.settings.python.pythonPath = vim.env.VIRTUAL_ENV and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python3")
      or utils.find_cmd("python3", ".venv/bin", config.root_dir)
  end
end

return {
  {
    "basedpyright",
    virtual = true,
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
              diagnosticMode = "workspace",
              -- diagnosticMode = "openFilesOnly",
              diagnosticSeverityOverrides = {
                -- https://detachhead.github.io/basedpyright/#/configuration?id=based-options
                reportAny = false,
                reportIgnoreCommentWithoutRule = false,
                reportImplicitRelativeImport = false,
                reportMissingTypeStubs = false,
                reportUnusedCallResult = false,
                reportUnusedImport = false,
                reportUnusedVariable = false,
              },
              typeCheckingMode = "all",
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
    "ruff",
    virtual = true,
    dependencies = {
      "neovim/nvim-lspconfig",
      "python_tools",
    },
    ft = function(spec)
      return lsp_utils.get_default_filetypes(spec.name)
    end,
    config = function(spec, _)
      ---@diagnostic disable-next-line:missing-fields
      setup(spec.name, {
        trace = "messages",
        init_options = {
          settings = {
            configurationPreference = "filesystemFirst",
            organizeImports = true,
            logLevel = "debug",
          },
        },
      })
    end,
  },
}
