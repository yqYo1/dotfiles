vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("init", { clear = true }),
  command = "startinsert",
  desc = "Automatically switch to insert mode when opening terminal",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("ContextfulMark", { clear = true }),
  callback = function(ctx)
    local op = vim.v.event.operator
    if not op then
      return
    end

    local win = vim.api.nvim_get_current_win()
    vim.schedule(function()
      -- Do lazily to avoid occasional failure on setting the mark.
      -- The issue typically occurs with `dd`.
      if vim.api.nvim_win_get_buf(win) == ctx.buf then
        local cursor = vim.api.nvim_win_get_cursor(win)
        vim.api.nvim_buf_set_mark(ctx.buf, op, cursor[1], cursor[2], {})
        vim.api.nvim_buf_set_mark(ctx.buf, string.upper(op), cursor[1], cursor[2], {})
      end
    end)
  end,
  desc = "Set marks after text yank",
})
