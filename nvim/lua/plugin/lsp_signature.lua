---@type LazySpec
return {
  "ray-x/lsp_signature.nvim",
  event = { "LspAttach" },
  opt = {
    hint_enable = false, -- disable hint on virtual text
    bind = true,
    handler_opts = {
      border = "rounded",
    },
    auto_close_after = 10,
    floating_window_off_x = 5, -- adjust float windows x position.
    floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
      -- local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
      local pumheight = vim.o.pumheight
      local winline = vim.fn.winline() -- line number in the window
      local winheight = vim.fn.winheight(0)

      -- window top
      if winline - 1 < pumheight then return pumheight end

      -- window bottom
      if winheight - winline < pumheight then return -pumheight end
      return 0
    end,
  },
}
