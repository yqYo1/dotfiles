-- clipboard
vim.keymap.set({ "n", "v" }, "gy", '"+y', { desc = "yank to clipboard" })
vim.keymap.set("n", "gp", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "gP", '"+P', { desc = "Paste from clipboard" })

--- Switch buffer
vim.keymap.set("n", "<C-j>", "<cmd>bprev<CR>", { desc = "Switch to previous buffer" })
vim.keymap.set("n", "<C-k>", "<cmd>bnext<CR>", { desc = "Switch to next buffer" })

-- terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Change to Normal mode" })

-- undo block
vim.keymap.set("i", "<Left>", "<C-G>U<Left>", { desc = "Move left without interrupting the Undo Block" })
vim.keymap.set("i", "<Right>", "<C-G>U<Right>", { desc = "Move left without interrupting the Undo Block" })

-- redo
vim.keymap.set("n", "U", "<C-r>", { desc = "redo" })

-- yank
vim.keymap.set("x", "y", "mzy`z", { desc = "don't move cusur when yank on Visual mode" })

-- delete
vim.keymap.set({ "n", "x" }, "x", '"_d', { desc = "Delete using blackhole register" })
vim.keymap.set("n", "X", '"_D', { desc = "Delete using blackhole register" })
vim.keymap.set("o", "x", "d", { desc = "Delete using x" })

-- Paste continuously in Visual mode
vim.keymap.set("x", "p", "P", { desc = "Paste without change register" })
vim.keymap.set("x", "P", "p", { desc = "Paste with change register" })

-- escape from insert
vim.keymap.set("i", "jk", "<Esc>", { desc = "Change to Normal mode" })

-- H/L submode
vim.keymap.set("n", "H", "H<Plug>(H)")
vim.keymap.set("n", "L", "L<Plug>(L)")
vim.keymap.set("n", "<Plug>(H)H", "<PageUp>H<Plug>(H)")
vim.keymap.set("n", "<Plug>(L)L", "<PageDown>Lzb<Plug>(L)")

-- disable default keymap
vim.keymap.set("n", "<C-r>", "<nop>", { desc = "Disable redo" })
