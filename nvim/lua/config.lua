local opt = vim.opt

--マウス
opt.mouse = "a"

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
