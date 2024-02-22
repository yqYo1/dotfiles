return {
	"SmiteshP/nvim-navic",
	dependencies = {
		"neovim/nvim-lspconfig",
		"onsails/lspkind.nvim",
	},
	config = function()
		vim.g.navic_silence = true

		local symbol_map = {}
		for key, value in pairs(require("lspkind").symbol_map) do
			symbol_map[key] = value .. " "
		end

		require("nvim-navic").setup({
			icons = symbol_map,
			highlight = false,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
		})
	end,
}
