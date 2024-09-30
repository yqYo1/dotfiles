return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  cond = not is_vscode(),
  dependencies = {
    { "onsails/lspkind.nvim" },
    { url = "https://codeberg.org/FelipeLema/cmp-async-path.git" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-calc" },
    { "hrsh7th/cmp-emoji" },
    { "tzachar/cmp-ai" },
    { "lukas-reineke/cmp-rg" },
    { "ray-x/cmp-treesitter" },
    { "saadparwaiz1/cmp_luasnip" }, -- Snippets source for nvim-cmp
    { "L3MON4D3/LuaSnip" }, -- Snippets plugin
  },
  config = function()
    vim.o.completeopt = "menuone,noinsert,noselect"

    -- Setup dependencies
    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    local setup_opt = {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({}),
      sorting = {
        comparator = {
          require("cmp_ai.compare"),
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
        { name = "cmp_ai", priority = 100 },
        { name = "nvim_lsp", priority = 100 },
        { name = "luasnip", priority = 100 },
        {
          name = "lazydev",
          group_index = 0,
          priority = 100,
        },
        {
          name = "async_path",
          option = {
            trailing_slash = true,
          },
          priority = 100,
        },
        { name = "emoji", insert = true, priority = 50 },
        { name = "nvim_lua", priority = 50 },
      }, {
        { name = "treesitter" },
        { name = "buffer" },
        --{ name = "omni" },
        { name = "calc" },
      }),
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      experimental = {
        ghost_text = false,
      },
    }

    local menu = {
      nvim_lsp = "[LSP]",
      luasnip = "[LSnip]",
      buffer = "[Buffer]",
      async_path = "[Path]",
      cmp_ai = "[AI]",
      nvim_lua = "[Lua]",
      spell = "[Spell]",
      calc = "[Calc]",
      emoji = "[Emoji]",
      neorg = "[Neorg]",
      rg = "[rg]",
      omni = "[Omni]",
      nvim_lsp_signature_help = "[Signature]",
      cmdline_history = "[History]",
    }

    local custom_menu_icon = {
      calc = " 󰃬 ",
      cmp_ai = "  ",
    }

    setup_opt.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        before = function(entry, vim_item)
          --menu
          if entry.source.name == "nvim_lsp" then
            vim_item.menu = "{" .. entry.source.source.client.name .. "}"
          else
            vim_item.menu = menu[entry.source.name] or entry.source.name
          end

          if entry.source.name == "calc" then
            -- Get the custom icon for 'calc' source
            -- Replace the kind glyph with the custom icon
            vim_item.kind = custom_menu_icon.calc
          elseif entry.source.name == "cmp_ai" then
            vim_item.kind = custom_menu_icon.cmp_ai
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
      }, {
        { name = "nvim_lsp_document_symbol" },
      }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        {
          name = "async_path",
          option = {
            trailing_slash = true,
          },
        },
      }, { { name = "cmdline" }, { { name = "cmdline_history" } } }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])
  end,
}
