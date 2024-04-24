local on_load = require("core.plugin").on_load

local M = {}

--@param name string
local le = function(name)
  on_load("telescope.nvim", function()
    require("telescope").load_extension(name)
  end)
end

M = {
  "nvim-telescope/telescope.nvim",
  cond = not is_vscode(),
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    --{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", config = le("fzf") },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      config = le("fzf"),
    },
    { "nvim-telescope/telescope-live-grep-args.nvim", config = le("live_grep_args") },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-github.nvim", config = le("gh") },
    { "tsakirist/telescope-lazy.nvim", config = le("lazy") },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*",
      callback = function()
        vim.cmd.stopinsert()
      end,
    })
  end,
}

M.le = le

return M
