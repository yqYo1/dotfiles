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
        inlayHints = {
          variableTypes = true,
          callArgumentTypes = true,
          callArgumentNamesMatching = true,
          functionReturnTypes = true,
          genericTypes = true,
        },
      },
    },
    python = {},
  },
}
