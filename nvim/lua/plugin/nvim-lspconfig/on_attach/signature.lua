return {
  on_attach = function(_, bufnr)
    require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window_off_x = 5, -- adjust float windows x position.
      floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
        -- local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
        local pumheight = vim.o.pumheight
        local winline = vim.fn.winline() -- line number in the window
        local winheight = vim.fn.winheight(0)

        -- window top
        if winline - 1 < pumheight then
          return pumheight
        end

        -- window bottom
        if winheight - winline < pumheight then
          return -pumheight
        end
        return 0
      end,
      --[[ floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
        local pumheight = vim.o.pumheight
        local winline = vim.fn.winline() -- line number in the window

        -- window top
        if winline - 1 < pumheight then
          return pumheight
        end

        --not window top
        return -pumheight
      end,
      hint_enable = false,
      handler_opts = {
        border = "rounded",
      }, ]]
    }, bufnr)
  end,
}
