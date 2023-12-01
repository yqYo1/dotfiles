require("lualine").setup({
	options = { theme = "gruvbox" },
})
require("bufferline").setup({})

require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
	...,
})

require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "ruff_fix", "ruff_format" },
		-- Use a sub-list to run only the first available formatter
	},
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
