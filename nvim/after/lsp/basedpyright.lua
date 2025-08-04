-- local is_windows = require("core.utils").is_windows()
-- local utils = require("core.utils")
-- local python_lsp_init = function(_, config)
--   if is_windows then
--     config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
--         and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "Scripts", "python")
--       or utils.find_cmd("python.exe", ".venv/Scripts", config.root_dir)
--   else
--     config.settings.python.pythonPath = vim.env.VIRTUAL_ENV and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python3")
--       or utils.find_cmd("python3", ".venv/bin", config.root_dir)
--   end
-- end

---@type vim.lsp.Config
return {
  -- before_init = python_lsp_init,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
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
