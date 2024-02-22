vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.confirm = true

vim.opt.shortmess:append("I")

vim.opt.number = true

vim.opt.fenc = "utf-8"
local tabwidth = 2
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.nrformats:remove({ "unsigned", "octal" })

vim.opt.list = true

vim.opt.listchars = {
	tab = "▸▹┊",
	trail = "▫",
	extends = "❯",
	precedes = "❮",
}
vim.opt.pumblend = 10
--vim.opt.laststatus = 0

--[[
local opt = vim.opt

opt.title = true

-- 全角文字表示設定
if not vim.g.vscode then
	opt.ambiwidth = "double"
end

opt.termguicolors = true

--インデントの幅
opt.tabstop = 2
opt.shiftwidth = 2

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8"

opt.swapfile = false
opt.backup = false
opt.hidden = true
opt.clipboard:append({ unnamedplus = true })
opt.fileformats = "unix"
opt.helplang = "ja"
]]
