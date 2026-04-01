local lsp_utils = require("core.lsp-utils")
local format_config = lsp_utils.format_config

---@param repo string
---@return string|nil
local function ghq_repo_path(repo)
  local result = vim
    .system({
      "ghq",
      "list",
      "--full-path",
      "--exact",
      repo,
    }, { text = true })
    :wait()

  if result.code ~= 0 then
    vim.notify(("ghq lookup failed for %s: %s"):format(repo, result.stderr or ""), vim.log.levels.ERROR)
    return nil
  end

  local path = vim.trim(result.stdout or "")
  if path == "" then
    vim.notify(("ghq returned empty path for %s"):format(repo), vim.log.levels.ERROR)
    return nil
  end

  return path
end

---@type string|nil
local flake_dir = ghq_repo_path("yqYo1/dotfiles")

---@type vim.lsp.Config
local config = {
  on_attach = format_config(true),
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
}

if flake_dir then
  config.settings.nixd.nixpkgs = {
    expr = ('let flake = builtins.getFlake "%s"; in import flake.inputs.nixpkgs { }'):format(flake_dir),
  }

  config.settings.nixd.options = {
    home_manager = {
      expr = ([[
let
  flake = builtins.getFlake "%s";

  # NOTE:
  # 現状は homeConfigurations が 1 つだけなので attrNames/head で十分。
  # ただし builtins.attrNames は属性名をアルファベット順で返すため、
  # 将来 homeConfigurations を複数持つようになったら
  # 意図しない設定を拾う可能性がある。
  username = builtins.head (builtins.attrNames flake.homeConfigurations);
in
  flake.homeConfigurations."${username}".options
]]):format(flake_dir),
    },
  }
end

return config
