local filetype_tabstop = { python = 4, cpp = 4 }
local usrftcfg = vim.api.nvim_create_augroup("UserFileTypeConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = usrftcfg,
  callback = function(args)
    local ftts = filetype_tabstop[args.match]
    if ftts then
      vim.bo.tabstop = ftts
      vim.bo.shiftwidth = ftts
    end
  end,
})
