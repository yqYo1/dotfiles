return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { "onsails/lspkind.nvim" },
    { "FelipeLema/cmp-async-path"},
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-omni" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-calc" },
    { "hrsh7th/cmp-emoji" },
    { "ray-x/cmp-treesitter" },
  },
  config = function()
    vim.o.completeopt = "menuone,noinsert,noselect"

    -- Setup dependencies
    local cmp = require("cmp")
    local types = require("cmp.types")
    local lspkind = require("lspkind")


    local setup_opt = {
      mapping = cmp.mapping.preset.insert({
      }),
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 100 },
        { name = "async_path", priority = 100 },
        { name = "emoji", insert = true, priority = 50 },
        { name = "nvim_lua", priority = 50 },
      }, {
        { name = "treesitter" },
        { name = "buffer" },
        { name = "omni" },
        { name = "calc" },
      }),
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      experimental = {
        ghost_text = false, -- this feature conflict to the copilot.vim's preview.
      },
    }

    local menu = {
      nvim_lsp = "[LSP]",
      buffer = "[Buffer]",
      async_path = "[Path]",
      nvim_lua = "[Lua]",
      ultisnips = "[UltiSnips]",
      spell = "[Spell]",
      calc = "[Calc]",
      emoji = "[Emoji]",
      neorg = "[Neorg]",
      rg = "[rg]",
      omni = "[Omni]",
      -- cmp_tabnine = "[Tabnine]",
      nvim_lsp_signature_help = "[Signature]",
      cmdline_history = "[History]",
    }

    setup_opt.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        before = function(entry, vim_item)
          if entry.source.name == "nvim_lsp" then
            vim_item.menu = "{" .. entry.source.source.client.name .. "}"
          else
            vim_item.menu = menu[entry.source.name] or entry.source.name
          end

          return vim_item
        end,
      }),
    }

    cmp.setup(setup_opt)

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "cmdline" },
      }, {
        { name = "buffer" },
      },{
        { name = 'nvim_lsp_document_symbol' }
      }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
      { { name = "async_path" } },
      { { name = "cmdline" }, { { name = "cmdline_history" } } }
      ),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])
  end,
}
