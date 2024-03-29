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
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
zc_source "$sheldon_cache"
unset sheldon_cache sheldon_toml

zc_source $ZSHRC_DIR/nolazy.zsh
zsh-defer source $ZSHRC_DIR/lazy.zsh
unfunction zc_source
eval "$(starship init zsh)"
