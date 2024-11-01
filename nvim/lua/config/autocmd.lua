vim.api.nvim_create_augroup("init", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = "init",
  command = "startinsert",
  desc = "Automatically switch to insert mode when opening terminal",
})
