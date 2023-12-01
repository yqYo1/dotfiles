require("config")
require("plugins")
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "plugins.lua" },
	command = "PackerCompile",
})
require("plugins_config")
require("nvim_cmp_config")
require("lsp_config")
