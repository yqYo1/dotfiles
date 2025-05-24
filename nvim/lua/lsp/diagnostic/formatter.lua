local M = {}

---@param msg string
---@param code string
---@param width number max_line_length
---@return string warapped_text
function M.wrap_text(msg, code, width)
  if not msg or #msg + #code < width then return msg .. " " .. code end
  if #msg <= width then return msg .. "\n" .. code end

  local lines = {}
  local current_pos = 1
  while current_pos <= #msg do
    local line_end = math.min(current_pos + width - 1, #msg)
    -- TODO: 単語単位での改行
    table.insert(lines, msg:sub(current_pos, line_end))
    current_pos = line_end + 1
  end
  return table.concat(lines, "\n")
end

---@param diagnostic vim.Diagnostic
---@return string フォーマットされた診断メッセージ
function M.format_diagnostic_message(diagnostic)
  local debug_msg = ""
  local lnum = diagnostic.lnum -- test

  local message = diagnostic.message
  local source = diagnostic.source
  local code = diagnostic.code or nil
  local win_width = vim.api.nvim_win_get_width(0)
  local bufnr = diagnostic.bufnr
  if bufnr then
    local win_ids = vim.fn.win_findbuf(bufnr)
    for _, win_id in ipairs(win_ids) do
      if win_width > vim.api.nvim_win_get_width(win_id) then win_width = vim.api.nvim_win_get_width(win_id) end
    end
  end

  local code_str
  if code then
    code_str = string.format("(%s: %s)", source, code)
  elseif source then
    code_str = string.format("(%s)", source)
  else
    code_str = ""
  end

  -- 1行の最大文字数を設定
  local wrap_width = win_width

  -- メッセージ部分を折り返す
  local wrapped_message = M.wrap_text(message, code_str, wrap_width)

  -- if code then
  --   return string.format("%s (%s: %s)", wrapped_message, source, code)
  -- else
  --   return string.format("%s (%s)", wrapped_message, source)
  -- end
  -- return string.format("buf_width:%s,bufnr:%s", buf_width, bufnr)
  debug_msg = debug_msg .. string.format("lnum:%s", lnum)
  return debug_msg
end

return M
