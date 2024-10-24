export FPATH="$ZSHRC_DIR/completion:$HOME/repos/eza/completions/zsh:$FPATH"
autoload -Uz compinit && compinit
export PATH="$HOME/.local/bin:$PATH"
if [ ! -d ~/.cache/Local/local-tmp-folder ]; then
  mkdir -p ~/.cache/Local/local-tmp-folder
fi
export TMPDIR="${HOME}/.cache/Local/local-tmp-folder"
alias ls=eza
alias ll='eza -alhF --git --git-repos'
alias vi=nvim
alias cls=clear
alias lg=lazygit
alias gp='git pull'
alias d='cd ~/dotfiles/'
alias ..='cd ../'
alias ...='cd ../../'
export AQUA_PROGRESS_BAR=true
source <(gh completion -s zsh)
source <(rye self completion -s zsh)
source <(jj util completion --zsh)
source <(podman completion zsh)
$(dirname $AQUA_GLOBAL_CONFIG)/update.sh
