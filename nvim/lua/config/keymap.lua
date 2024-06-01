-- yank to clipboard
vim.keymap.set({ "n", "v" }, "gy", '"+y')
vim.keymap.set("n", "gp", '"+p')
vim.keymap.set("n", "gP", '"+P')

vim.keymap.set("n", "<C-j>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>bnext<CR>")
