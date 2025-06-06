local is_vscode = require("core.utils").is_vscode

local function load_after(plugin)
  local dir = plugin.dir .. "/after/plugin"
  local fd = vim.uv.fs_scandir(dir)
  if not fd then
    return
  end
  while true do
    local file_name, type = vim.uv.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type == "file" then
      vim.cmd.source(dir .. "/" .. file_name)
    end
  end
end

---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  cond = not is_vscode(),
  enabled = false,
  dependencies = {
    { "onsails/lspkind.nvim" },
    {
      url = "https://codeberg.org/FelipeLema/cmp-async-path.git",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-buffer",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-nvim-lsp",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-nvim-lua",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-cmdline",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-calc",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "hrsh7th/cmp-emoji",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "lukas-reineke/cmp-rg",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "ray-x/cmp-treesitter",
      config = function(p)
        load_after(p)
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      opts = {},
      -- config = function(p)
      --   require("copilot_cmp").setup()
      --   load_after(p)
      -- end,
    },
    {
      "chrisgrieser/cmp-nerdfont",
      config = function(p)
        load_after(p)
      end,
    },
    -- {
    --   "lukas-reineke/cmp-under-comparator"
    -- },
    -- { "saadparwaiz1/cmp_luasnip" }, -- Snippets source for nvim-cmp
    -- { "L3MON4D3/LuaSnip" }, -- Snippets plugin
  },
  config = function()
    vim.o.completeopt = "menuone,noinsert,noselect"

    -- Setup dependencies
    -- local luasnip = require("luasnip")
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        -- if vim.api.nvim_buf_get_option_value("buftype", { buf = 0 }) == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local setup_opt = {
      -- snippet = {
      --   expand = function(args)
      --     luasnip.lsp_expand(args.body)
      --   end,
      -- },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          -- elseif luasnip.locally_jumpable(1) then
          --   luasnip.jump(1)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sorting = {
        comparator = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          -- require("cmp_under_comparator").under,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      sources = {
        {
          name = "nvim_lsp",
          priority = 100,
          -- group_index = 1,
        },
        {
          name = "copilot",
          priority = 90,
        },
        {
          name = "lazydev",
          -- group_index = 0,
          priority = 70,
        },
        {
          name = "async_path",
          option = {
            trailing_slash = true,
          },
          priority = 100,
        },
        {
          name = "emoji",
          insert = true,
          priority = 50,
        },
        {
          name = "nerdfont",
          priority = 50,
        },
        {
          name = "nvim_lua",
          priority = 60,
        },
        {
          name = "treesitter"
        },
        {
          name = "buffer",
          -- group_index = 2,
        },
        { name = "calc" },
      },
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      experimental = {
        ghost_text = false,
      },
    }

    local menu = {
      nvim_lsp = "[LSP]",
      lazydev = "[LazyDev]",
      luasnip = "[LSnip]",
      copilot = "[Copilot]",
      buffer = "[Buffer]",
      async_path = "[Path]",
      treesitter = "[TS]",
      nvim_lua = "[Lua]",
      spell = "[Spell]",
      calc = "[Calc]",
      emoji = "[Emoji]",
      nerdfont = "[Nerd]",
      neorg = "[Neorg]",
      rg = "[rg]",
      nvim_lsp_signature_help = "[Signature]",
    }

    setup_opt.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        -- prevent the popup from showing more than provided characters
        -- (e.g 50 will not show more than 50 characters)
        maxwidth = 50,
        before = function(entry, vim_item)
          --menu
          if entry.source.name == "nvim_lsp" then
            vim_item.menu = "[" .. entry.source.source.client.name .. "]"
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
        { name = "buffer" },
      }, {
        { name = "nvim_lsp_document_symbol" },
      }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    cmp.setup.cmdline("?", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
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
      }, {
        { name = "cmdline" },
      }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    -- copilot suggestion hidden
    -- from https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#suggestion
    cmp.event:on("menu_opened", function()
      vim.b.copilot_suggestion_hidden = true
    end)

    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)
  end,
}
