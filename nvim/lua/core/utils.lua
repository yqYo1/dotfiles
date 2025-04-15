local M = {}

M.is_event_available = function(event)
  return M.tb(vim.fn.exists(("##" .. event)))
end

M.find_cmd = function(cmd, prefixes, start_from, stop_at)
  local path = require("lspconfig.util").path

  if type(prefixes) == "string" then
    prefixes = { prefixes }
  end

  local found
  for _, prefix in ipairs(prefixes) do
    local full_cmd = prefix and path.join(prefix, cmd) or cmd
    local possibility

    -- if start_from is a dir, test it first since transverse will start from its parent
    if start_from and path.is_dir(start_from) then
      possibility = path.join(start_from, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        break
      end
    end

    path.traverse_parents(start_from, function(dir)
      possibility = path.join(dir, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        return true
      end
      -- use cwd as a stopping point to avoid scanning the entire file system
      if stop_at and dir == stop_at then
        return true
      end
    end)

    if found ~= nil then
      break
    end
  end

  return found or cmd
end

function M.redetect_filetype()
  vim.bo.filetype = vim.bo.filetype
end

function M.repeat_element(x, n)
  local tbl = {}
  for _ = 1, n, 1 do
    table.insert(tbl, x)
  end
  return tbl
end

M.tb = function(value)
  if value == nil then
    return false
  elseif type(value) == "boolean" then
    return value
  elseif type(value) == "number" then
    return value ~= 0
  elseif type(value) == "string" then
    return string.lower(value) == "true"
  else
    return false
  end
end

M.is_vscode = function()
  return M.tb(vim.g.vscode)
end

M.is_windows = function()
  return vim.uv.os_uname().sysname == "Windows_NT"
end

return M
