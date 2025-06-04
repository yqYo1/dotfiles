vim.g.mapleader = " "

-- clipboard
vim.keymap.set({ "n", "v" }, "gy", '"+y', { desc = "yank to clipboard" })
vim.keymap.set("n", "gp", '"+pmpmP', { desc = "Paste from clipboard" })
vim.keymap.set("n", "gP", '"+PmpmP', { desc = "Paste from clipboard" })
vim.keymap.set("x", "gp", '"+PmpmP', { desc = "Paste from clipboard" })
vim.keymap.set("x", "gP", '"+pmpmP', { desc = "Paste from clipboard" })

-- redo
vim.keymap.set("n", "U", "<C-r>mrmR", { desc = "redo" })

-- undo
vim.keymap.set("n", "u", "umumU", { desc = "undo" })

-- yank
vim.keymap.set("x", "y", "mzy`z", { desc = "don't move cusur when yank on Visual mode" })

-- delete
vim.keymap.set({ "n", "x" }, "x", '"_d', { desc = "Delete using blackhole register" })
vim.keymap.set("n", "X", '"_D', { desc = "Delete using blackhole register" })
vim.keymap.set("o", "x", "d", { desc = "Delete using x" })

-- Paste
vim.keymap.set("n", "p", "pmpmP", { desc = "Paste" })
vim.keymap.set("n", "P", "PmpmP", { desc = "Paste" })

-- Paste continuously in Visual mode
vim.keymap.set("x", "p", "PmpmP", { desc = "Paste without change register" })
vim.keymap.set("x", "P", "pmpmP", { desc = "Paste with change register" })

-- undo block wo interrupt
vim.keymap.set("i", "<Left>", "<C-G>U<Left>", { desc = "Move left without interrupting the Undo Block" })
vim.keymap.set("i", "<Right>", "<C-G>U<Right>", { desc = "Move left without interrupting the Undo Block" })

-- escape from insert
vim.keymap.set("i", "jk", "<Esc>", { desc = "Change to Normal mode" })

--- Switch buffer
vim.keymap.set("n", "<C-j>", "<cmd>bprev<CR>", { desc = "Switch to previous buffer" })
vim.keymap.set("n", "<C-k>", "<cmd>bnext<CR>", { desc = "Switch to next buffer" })

-- terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Change to Normal mode" })

-- H/L submode
vim.keymap.set("n", "H", "H<Plug>(H)")
vim.keymap.set("n", "L", "L<Plug>(L)")
vim.keymap.set("n", "<Plug>(H)H", "<PageUp>H<Plug>(H)")
vim.keymap.set("n", "<Plug>(L)L", "<PageDown>Lzb<Plug>(L)")

-- Window move and resize submode
vim.keymap.set("n", "<C-w>h", "<C-w>h<Plug>(WindowMoveAndResize)", { desc = "Go to the left window" })
vim.keymap.set("n", "<C-w>j", "<C-w>j<Plug>(WindowMoveAndResize)", { desc = "Go to the down window" })
vim.keymap.set("n", "<C-w>k", "<C-w>k<Plug>(WindowMoveAndResize)", { desc = "Go to the up window" })
vim.keymap.set("n", "<C-w>l", "<C-w>l<Plug>(WindowMoveAndResize)", { desc = "Go to the right window" })

vim.keymap.set("n", "<C-w>H", "<C-w>H<Plug>(WindowMoveAndResize)", { desc = "Move window to far left" })
vim.keymap.set("n", "<C-w>J", "<C-w>J<Plug>(WindowMoveAndResize)", { desc = "Move window to far bottom" })
vim.keymap.set("n", "<C-w>K", "<C-w>K<Plug>(WindowMoveAndResize)", { desc = "Move window to far top" })
vim.keymap.set("n", "<C-w>L", "<C-w>L<Plug>(WindowMoveAndResize)", { desc = "Move window to far right" })

vim.keymap.set("n", "<C-w>s", "<C-w>s<Plug>(WindowMoveAndResize)", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-w>v", "<C-w>v<Plug>(WindowMoveAndResize)", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-w>q", "<C-w>q<Plug>(WindowMoveAndResize)", { desc = "Quit a window" })

vim.keymap.set("n", "<C-w>+", "<cmd>resize +1<CR><Plug>(WindowMoveAndResize)", { desc = "Increase height" })
vim.keymap.set("n", "<C-w>-", "<cmd>resize -1<CR><Plug>(WindowMoveAndResize)", { desc = "Decrease height"})
vim.keymap.set("n", "<C-w>>", "<cmd>virtical resize +1<CR><Plug>(WindowMoveAndResize)", { desc = "Increase width" })
vim.keymap.set("n", "<C-w><lt>", "<cmd>virtical resize -1<CR><Plug>(WindowMoveAndResize)", { desc = "Decrease width"})
vim.keymap.set("n", "<C-w>=", "<cmd>wincmd =<CR><Plug>(WindowMoveAndResize)", { desc = "Equally high and wide"})

vim.keymap.set("n", "<Plug>(WindowMoveAndResize)h", "<C-w>h", { remap = true, desc = "Go to the left window" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)j", "<C-w>j", { remap = true, desc = "Go to the down window" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)k", "<C-w>k", { remap = true, desc = "Go to the up window" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)l", "<C-w>l", { remap = true, desc = "Go to the right window" })

vim.keymap.set("n", "<Plug>(WindowMoveAndResize)H", "<C-w>H", { remap = true, desc = "Move window to far left" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)J", "<C-w>J", { remap = true, desc = "Move window to far bottom" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)K", "<C-w>K", { remap = true, desc = "Move window to far top" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)L", "<C-w>L", { remap = true, desc = "Move window to far right" })

vim.keymap.set("n", "<Plug>(WindowMoveAndResize)s", "<C-w>s", { remap = true, desc = "Split window horizontally" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)v", "<C-w>v", { remap = true, desc = "Split window vertically" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)q", "<C-w>q", { remap = true, desc = "Quit a window" })

vim.keymap.set("n", "<Plug>(WindowMoveAndResize)+", "<C-w>+", { remap = true, desc = "Increase width" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)-", "<C-w>-", { remap = true, desc = "Decrease width"})
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)>", "<C-w>>", { remap = true, desc = "Increase height" })
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)<lt>", "<C-w><lt>", { remap = true, desc = "Decrease height"})
vim.keymap.set("n", "<Plug>(WindowMoveAndResize)=", "<C-w>=", { remap = true, desc = "Equally high and wide"})

vim.keymap.set("n", "<Plug>(WindowMoveAndResize)<Esc>" ,"<Nop>", { desc = "Exit submode" })

-- disable default keymap
vim.keymap.set("n", "<C-r>", "<nop>", { desc = "Disable default keymap" })
