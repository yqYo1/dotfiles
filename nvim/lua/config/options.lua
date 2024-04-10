local opt = vim.opt

opt.backup = true
opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
opt.swapfile = false
opt.writebackup = true
opt.autoread = true
opt.hidden = true
opt.mouse = "a"
opt.confirm = true

opt.shortmess:append("I")

opt.number = true
opt.relativenumber = true

opt.fenc = "utf-8"

local tabwidth = 2
opt.tabstop = tabwidth
opt.softtabstop = tabwidth
opt.shiftwidth = tabwidth
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.backspace = { "indent", "eol", "start" }
opt.nrformats:remove({ "unsigned", "octal" })

opt.list = true

opt.listchars = {
  tab = "▸▹┊",
  trail = "▫",
  extends = "❯",
  precedes = "❮",
}
opt.pumblend = 10

vim.diagnostic.config({ severity_sort = true })
--opt.laststatus = 0

--[[
local opt = opt

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
