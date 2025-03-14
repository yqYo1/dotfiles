local M = {}

M.showInlayHint = true

local function setInlayHintHL()
  local has_hl, hl = pcall(vim.api.nvim_get_hl_by_name, "LspInlayHint", true)
  if has_hl and (hl["foreground"] or hl["background"]) then
    return
  end

  hl = vim.api.nvim_get_hl_by_name("Comment", true)
  local foreground = string.format("#%06x", hl["foreground"] or 0)
  if #foreground < 3 then
    foreground = ""
  end

  hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
  local background = string.format("#%06x", hl["background"] or 0)
  if #background < 3 then
    background = ""
  end

  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = foreground, bg = background })
end

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
