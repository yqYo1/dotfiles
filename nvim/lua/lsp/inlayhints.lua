local M = {}

---@type boolean
M.showInlayHint = true

M.enable = function()
  M.showInlayHint = true
  vim.lsp.inlay_hint.enable(true)
end

M.disable = function()
  M.showInlayHint = false
  vim.lsp.inlay_hint.enable(false)
end

M.toggle = function()
  if M.showInlayHint then
    M.disable()
  else
    M.enable()
  end
end

M.setup = function()
  vim.api.nvim_create_user_command("InlayHintToggle", M.toggle, { nargs = 0 })
  vim.api.nvim_create_user_command("InlayHintEnable", M.enable, { nargs = 0 })
  vim.api.nvim_create_user_command("InlayHintDisable", M.disable, { nargs = 0 })
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      vim.lsp.inlay_hint.enable(M.showInlayHint, { bufnr = args.buf })
    end,
    desc = "Enable inlay hints on LspAttach if server supports it and inlayHint is enabled",
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function(args)
      vim.lsp.inlay_hint.enable(M.showInlayHint, { bufnr = args.buf })
    end,
    desc = "Enable inlay hints on InsertLeave if server supports it and inlayHint is enable",
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function(args)
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end,
    desc = "Disable inlay hints on InsertEnter",
  })
end

return M
