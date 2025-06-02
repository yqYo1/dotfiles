local M = {}

M.showInlayHint = true

M.setup = function()
  vim.lsp.inlay_hint.enable(M.showInlayHint)

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.lsp.inlay_hint.enable(M.showInlayHint, { bufnr = 0 })
    end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
    end,
  })
end

return M
