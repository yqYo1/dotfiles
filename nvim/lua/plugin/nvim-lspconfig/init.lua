local utils = require("core.utils")

local function has_cmp()
  return require("core.plugin").has("nvim-cmp")
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile", "VeryLazy" },
  dependencies = {
    "node_servers",
    "python_tools",
    "cli",
    "b0o/schemastore.nvim",
    { "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-signature-help", cond = has_cmp },
  },
  init = function()
    require("core.plugin").on_attach(function(client, bufnr)
      local exclude_ft = { "oil" }
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      if vim.tbl_contains(exclude_ft, ft) then
        return
      end

      --require("plugin.nvim-lspconfig").on_attach(client, bufnr)

      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end)
  end,
  opts = function()
    ---@class LSPConfigOpts
    local o = { lsp_opts ={} }

    o.lsp_opts.capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
    )

    o.lsp_opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    o.html_like = {
      "astro",
      "html",
      "htmldjango",
      "css",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
      "markdown",
    }

    o.typescriptInlayHints = {
      parameterNames = {
        enabled = "literals", --'none' | 'literals' | 'all'
        suppressWhenArgumentMatchesName = true,
      },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValus = { enabled = true },
    }

    function o.format_config(enabled)
      return function(client)
        client.server_capabilities.documentFormattingProvider = enabled
        client.server_capabilities.documentRangeFormattingProvider = enabled
      end
    end

    function o.setup(client, extra_opts)
      if type(client) == "string" then
        client = require("lspconfig")[client]
      end

      local default_opts = client.document_config.default_config

      local local_opts = vim.tbl_deep_extend("force", {}, o.lsp_opts, extra_opts or {})

      local_opts.filetypes =vim.tbl_flatten({
        local_opts.filetypes or default_opts.filetypes or {},
        local_opts.extra_filetypes or {},
      })
      local_opts.extra_filetypes = nil
      client.setup(local_opts)
    end

    return o
  end,
  ---@param _ any
  ---@param opts LSPConfigOpts
  config = function(_, opts)
    local format_config = opts.format_config
    local setup = opts.setup
    local html_like = opts.html_like
    local typescriptInlayHints = opts.typescriptInlayHints

    local lspconfig = require("lspconfig")

    --server config
    setup(lspconfig.efm, {
      filetypes = vim.tbl_flatten({
        {
          "lua",
          "python",
          "go",
          "rust",
        },
        {
          "json",
          "jsonc",
          "yaml",
        },
        {
          "dockerfile",
        },
        {
          "html",
          "svelte",
          "vue",
          "astro",
          "javascriptreact",
          "javascript.jsx",
          "typescriptreact",
          "typescript.tsx",
          "markdown",
          "markdown.mdx",
          "css",
          "scss",
          "less",
          "javascript",
          "typescript",
        },
      }),
      init_options = {
        documentFormatting = true,
        rangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true,
      },
    })

    setup(lspconfig.lua_ls, {
      on_attach = format_config(false),
      flags = {
        debouce_text_changes = 150,
      },
      settings = {
        Lua = {
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
    })

    setup(lspconfig.jsonls, {
      on_attach = format_config(false),
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
          format = { enable = true },
        },
      },
    })

    setup(lspconfig.yamlls, {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas({
            extra = {
              {
                name = "openAPI 3.0",
                url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml",
              },
              {
                name = "openAPI 3.1",
                url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml",
              },
            },
          }),
          validate = true,
          format = { enable = true },
        },
      },
    })

    local python_lsp_init = function(_, config)
      config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
      and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
      or utils.find_cmd("python3", ".venv/bin", config.root_dir)
    end
    setup(lspconfig.ruff_lsp, { before_init = python_lsp_init })
  end,
}
