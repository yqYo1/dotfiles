ZSHRC_DIR=${${(%):-%N}:A:h}

function zc_source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}
ensure_zcompiled ~/.zshrc
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
sheldon_cache="$XDG_CONFIG_HOME/sheldon/sheldon.zsh"
sheldon_toml="$XDG_CONFIG_HOME/sheldon/plugins.toml"
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
zc_source "$sheldon_cache"
unset sheldon_cache sheldon_toml

zc_source $ZSHRC_DIR/nolazy.zsh
zsh-defer source $ZSHRC_DIR/lazy.zsh
unfunction zc_source
eval "$(starship init zsh)"
