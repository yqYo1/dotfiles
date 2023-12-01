require("lspkind").init({
	-- DEPRECATED (use mode instead): enables text annotations
	--
	-- default: true
	-- with_text = true,

	-- defines how annotations are shown
	-- default: symbol
	-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
	mode = "symbol_text",

	-- default symbol map
	-- can be either 'default' (requires nerd-fonts font) or
	-- 'codicons' for codicon preset (requires vscode-codicons font)
	--
	-- default: 'default'
	preset = "codicons",

	-- override preset symbols
	--
	-- default: {}
	symbol_map = {
		Text = "󰉿",
		Method = "󰆧",
		Function = "󰊕",
		Constructor = "",
		Field = "󰜢",
		Variable = "󰀫",
		Class = "󰠱",
		Interface = "",
		Module = "",
		Property = "󰜢",
		Unit = "󰑭",
		Value = "󰎠",
		Enum = "",
		Keyword = "󰌋",
		Snippet = "",
		Color = "󰏘",
		File = "󰈙",
		Reference = "󰈇",
		Folder = "󰉋",
		EnumMember = "",
		Constant = "󰏿",
		Struct = "󰙅",
		Event = "",
		Operator = "󰆕",
		TypeParameter = "",
	},
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pylsp",
		"ruff_lsp",
		"rust_analyzer",
		"powershell_es",
	},
})
require("lspconfig").lua_ls.setup({})
require("lspconfig").pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				flake8 = {
					maxLineLength = 256,
				},
				autopep8 = {
					enabled = false,
				},
				pycodestyle = {
					maxLineLength = 256,
				},
				pyflakes = {
					enabled = false,
				},
				pylint = {
					enabled = false,
				},
			},
		},
	},
})
require("lspconfig").ruff_lsp.setup({
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {},
		},
	},
})

require("lspconfig").rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
		},
	},
})

require("lint").linter_by_ft = {
	python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

--[[
local null_ls = require("null-ls")
null_ls.setup({
sources = {
--null_ls.builtins.formatting.black, -- python formatter
--null_ls.builtins.formatting.isort, -- python import sort
--null_ls.builtins.diagnostics.flake8.with(
--[[	{extra_args = {"--max-line-length","256"}}
), -- python linter
null_ls.builtins.formatting.stylua, -- lua formatter
},
})
]]
