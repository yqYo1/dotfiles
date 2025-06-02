local M = {}

M.showInlayHint = true

M.on_attach = function(client, bufnr)
  local supports_inlay_hint = client.server_capabilities.inlayHintProvider

  if supports_inlay_hint then
    -- keymap(bufnr)

    -- setInlayHintHL()

    vim.lsp.inlay_hint.enable(M.showInlayHint, { bufnr })

    vim.api.nvim_create_autocmd("InsertLeave", {
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(M.showInlayHint, { bufnr })
      end,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(false, { bufnr })
      end,
    })
  end
end

return M
