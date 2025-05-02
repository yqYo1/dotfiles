local M = require("lualine.component"):extend()

M.active_requests = {}
M.spinner_index = 1

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}

local spinner_sysmbols_len = #spinner_symbols

---@diagnostic disable-next-line: duplicate-set-field
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        if request.data and request.data.id then
          -- リクエストIDを保存
          self.active_requests[request.data.id] = true
        end
      elseif request.match == "CodeCompanionRequestFinished" then
        if request.data and request.data.id then
          -- 完了したリクエストをリストから削除
          self.active_requests[request.data.id] = nil
        end
      end
    end,
  })
end

---@diagnostic disable-next-line: duplicate-set-field
function M:update_status()
  local has_active_requests = false
  for _, _ in pairs(self.active_requests) do
    has_active_requests = true
    break
  end

  if has_active_requests then
    self.spinner_index = (self.spinner_index % spinner_sysmbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
