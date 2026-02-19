export HISTFILE=$ZSHRC_DIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000
export BUN_INSTALL="$HOME/.bun"
export RYE_HOME="$XDG_CONFIG_HOME/rye"
export PATH="$BUN_INSTALL/bin:$PATH"
export ARDUINO_UPDATER_ENABLE_NOTIFICATION=false
source $HOME/.cargo/env
export SYSTEMD_EDITOR=nvim
zshaddhistory() {
  [[ "$?" == 0 ]]
}
setopt no_auto_pushd
setopt no_beep
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

export FPATH="$ZSHRC_DIR/completion:$FPATH"
zstyle ':autocomplete::compinit' arguments -C
