local is_windows = require("core.utils").is_windows
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.neovim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.confirm = true

vim.opt.shortmess:append("I")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.fenc = "utf-8"

vim.opt.wrap = true
-- 単語単位で折り返す
vim.opt.linebreak = true

--indent
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

vim.opt.cmdheight = 0

vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

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
    vim.opt[k] = v
  end
else
  local function resilient_osc52_paste()
    -- weztermなどのterminalはOSC52の読み取りをサポートしない為無名レジスタにフォールバック
    return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
  end

  vim.g.clipboard = {
    name = "OSC52-Resilient",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = resilient_osc52_paste,
      ["*"] = resilient_osc52_paste,
    },
  }
end
