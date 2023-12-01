
export HISTFILE=$ZSHRC_DIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
source $HOME/.cargo/env
eval "$(gh completion -s zsh)"
export FPATH="$HOME/repos/eza/completions/zsh:$FPATH"
autoload -Uz compinit && compinit
