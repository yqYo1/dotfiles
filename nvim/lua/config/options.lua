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

opt.termguicolors = true
opt.winblend = 0
opt.pumblend = 0

vim.diagnostic.config({ severity_sort = true })

if is_windows() then
  local pwsh_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for k, v in pairs(pwsh_options) do
    opt[k] = v
  end
end
