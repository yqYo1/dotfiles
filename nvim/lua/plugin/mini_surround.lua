---@type LazySpec
return {
  "echasnovski/mini.surround",
  version = false,
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "sa",
      delete = "sd",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      replace = "sr",

      suffix_last = "l",
      suffix_next = "n",
    },
    n_lines = 100,
    search_method = "cover_or_next",
  },
}
