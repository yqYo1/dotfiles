local utils = require("core.utils")
local lsp_utils = require("plugin.nvim-lspconfig.uitls")
local has_cmp = lsp_utils.has_cmp()

return {
  {
    import = "plugin.nvim-lspconfig.servers",
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    cond = not is_vscode(),
    dependencies = {
      "node_servers",
      "python_tools",
      "b0o/schemastore.nvim",
      "ray-x/lsp_signature.nvim",
      --"lspcontainers/lspcontainers.nvim",
      { "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
      { "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
      { "hrsh7th/cmp-nvim-lsp-signature-help", cond = has_cmp },
    },
    init = function()
      require("core.plugin").on_attach(function(client, bufnr)
        local exclude_ft = { "oil" }
        local ft = vim.bo.filetype
        if vim.tbl_contains(exclude_ft, ft) then
          return
        end

        local on_attach = require("plugin.nvim-lspconfig.on_attach")
        on_attach(client, bufnr)

        vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      end)
    end,
    opts = function()
      ---@class LSPConfigOpts
      local o = { lsp_opts = {} }

      o.lsp_opts.capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and require("cmp_nvim_lsp").default_capabilities() or {}
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

        local_opts.filetypes = vim.tbl_flatten({
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
      local setup = opts.setup

      local lspconfig = require("lspconfig")

      local python_lsp_init = function(_, config)
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
            and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
          or utils.find_cmd("python3", ".venv/bin", config.root_dir)
      end

      setup(lspconfig.pylsp, {
        before_init = python_lsp_init,
        settings = {
          pylsp = {
            plugins = {
              ruff = {
                enabled = true, -- Enable the plugin
                formatEnabled = true, -- Enable formatting using ruffs formatter
                extendSelect = { "I" }, -- Rules that are additionally used by ruff
                extendIgnore = { "C90" }, -- Rules that are additionally ignored by ruff
                format = { "I" }, -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                severities = { ["D212"] = "I" }, -- Optional table of rules where a custom severity is desired
                unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                lineLength = 88, -- Line length to pass to ruff checking and formatting
                select = { "F" }, -- Rules to be enabled by ruff
                ignore = { "D210" }, -- Rules to be ignored by ruff
                preview = false, -- Whether to enable the preview style linting and formatting.
                targetVersion = "py310", -- The minimum python version to target (applies for both linting and formatting).
              },
            },
          },
        },
      })

      setup(lspconfig.pyright, {
        before_init = python_lsp_init,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      })
    end,
  },
}
