export HISTFILE=$ZSHRC_DIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
export BUN_INSTALL="$HOME/.bun"
export RYE_HOME="$XDG_CONFIG_HOME/rye"
export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
export PATH="$BUN_INSTALL/bin:$PATH"
source $HOME/.cargo/env
zshaddhistory() {
  [[ "$?" == 0 ]]
}
setopt no_auto_pushd
setopt no_beep
setopt hint_expand
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
