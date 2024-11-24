-- yank to clipboard
vim.keymap.set({ "n", "v" }, "gy", '"+y')
vim.keymap.set("n", "gp", '"+p')
vim.keymap.set("n", "gP", '"+P')

-- Buffer switch
vim.keymap.set("n", "<C-j>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>bnext<CR>")

-- Terminal escape insert mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Make sure Undo Block is not interrupted
vim.keymap.set("i", "<Left>", "<C-G>U<Left>")
vim.keymap.set("i", "<Right>", "<C-G>U<Right>")

-- redo
vim.keymap.set("n", "U", "<C-r>")

-- don't move cusur when yank on Visual mode
vim.keymap.set("x", "y", "mzy`z")

-- Paste continuously in Visual mode
vim.keymap.set("x", "p", "P")

-- escape from insert
vim.keymap.set("i", "jk", "<Esc>")

-- H/L submode
vim.keymap.set("n", "H", "H<Plug>(H)")
vim.keymap.set("n", "L", "L<Plug>(L)")
vim.keymap.set("n", "<Plug>(H)H", "<PageUp>H<Plug>(H)")
vim.keymap.set("n", "<Plug>(L)L", "<PageDown>Lzb<Plug>(L)")
