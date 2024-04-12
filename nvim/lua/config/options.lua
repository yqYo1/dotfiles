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
