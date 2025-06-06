local M = {}

local Util = require("lazy.core.util")

M.autoformat = true

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    Util.info("Enabled format on save", { title = "Format" })
  else
    Util.warn("Disabled format on save", { title = "Format" })
  end
end

function M.enable()
  vim.b.autoformat = nil
  M.autoformat = true
  Util.info("Enabled format on save", { title = "Format" })
end

function M.disable()
  M.autoformat = false
  Util.warn("Disabled format on save", { title = "Format" })
end

---@param opts? {force?:boolean}
function M.format(opts)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false and not (opts and opts.force) then
    return
  end
  --local ft = vim.bo[buf].filetype

  vim.lsp.buf.format({
    bufnr = buf,
    timeout_ms = 5000,
    filter = function(client)
      if not client.server_capabilities.documentFormattingProvider then
        return false
      end
      Util.info("format on save", { title = client.name })
      return true
    end,
  })
  vim.cmd("retab")
end

local function command()
  vim.api.nvim_create_user_command("FormatToggle", M.toggle, { nargs = 0 })
  vim.api.nvim_create_user_command("FormatEnable", M.enable, { nargs = 0 })
  vim.api.nvim_create_user_command("FormatDisable", M.disable, { nargs = 0 })
  vim.api.nvim_create_user_command("Format", M.format, { nargs = 0 })
end

local function init_auto_format(buf)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
    buffer = buf,
    callback = function()
      if M.autoformat then
        M.format()
      end
    end,
  })
end

function M.on_attach(client, buf)
  if client.server_capabilities.documentFormattingProvider then
    command()
    init_auto_format(buf)
  end
end

return M
