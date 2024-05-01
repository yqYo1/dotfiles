export HISTFILE=$ZSHRC_DIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
export BUN_INSTALL="$HOME/.bun"
export AQUA_PROGRESS_BAR=true
export RYE_HOME="$XDG_CONFIG_HOME/rye"
export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
export PATH="$BUN_INSTALL/bin:$PATH"
source $RYE_HOME/env
#source $HOME/.cargo/env
export FPATH="$ZSHRC_DIR/completion:$HOME/repos/eza/completions/zsh:$FPATH"
autoload -Uz compinit && compinit
