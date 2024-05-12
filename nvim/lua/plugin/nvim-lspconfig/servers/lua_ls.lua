local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config

--local i = require("plenary.iterators")

---@param names string[]
---@return string[]
local function get_plugin_paths(names)
  local plugins = require("lazy.core.config").plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end

--[[
---@param names string[]
---@return Iterator<string>
local function get_plugin_paths(names)
  local plugins = require("lazy.core.config").plugins
  return i.iter(names)
    :filter(function(n)
      local ia = plugins[n] ~= nil
      if not ia then
        vim.notify("Invalid plugin name: " .. n)
      end
      return ia
    end)
    :map(function(n)
      return plugins[n].dir .. "/lua"
    end)
end
]]

---@param plugins string[]
---@return string[]
local function library(plugins)
  local paths = get_plugin_paths(plugins)
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end
--[[
---@param plugins string[]
---@return string[]
local function library(plugins)
  local paths = get_plugin_paths(plugins)

  return i.iter({
    vim.fn.stdpath("config") .. "/lua",
    vim.env.VIMRUNTIME .. "/lua",
    "${3rd}/luv/library",
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
  })
    :chain(paths)
    :tolist()
end
]]

return {
  name = "lua_ls",
  dir = "",
  dependencies = { "neovim/nvim-lspconfig" },
  ft = function(spec)
    return lsp_utils.get_default_filetypes(spec.name)
  end,
  opts = function()
    return {
      on_attach = format_config(false),
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            pathStrict = true,
            path = { "?.lua", "?/init.lua" },
          },
          workspace = {
            library = library({
              "lazy.nvim",
              "oil.nvim",
              "noice.nvim",
              "nvim-cmp",
              "nvim-lspconfig",
            }),
            checkThirdParty = "Disable",
          },
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            showWord = "Disable",
            callSnippet = "Replace",
          },
          format = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      },
    }
  end,
  config = function(spec, opts)
    setup(spec.name, opts)
  end,
}
