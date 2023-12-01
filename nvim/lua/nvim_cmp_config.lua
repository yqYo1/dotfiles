
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
	    completion = cmp.config.window.bordered(),
	    documentation = cmp.config.window.bordered(),
	},
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    }),
    sources = cmp.config.sources(
        {
            { name = "nvim_lsp" },
        }, {
            { name = "buffer" },
        }, {
          { name = 'nvim_lsp_signature_help' }
        }, {
          { name = 'async_path' }
        }
    )
  --[[
  experimental = {
    ghost_text = true,
  },
  ]]
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
        {
          { name = 'async_path' }
        }, {
          { name = 'cmdline' }
        }
    )
})

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}
