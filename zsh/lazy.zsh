export FPATH="$ZSHRC_DIR/completion:$HOME/repos/eza/completions/zsh:$FPATH"
autoload -Uz compinit && compinit
export PATH="$HOME/.local/bin:$PATH"
if [ ! -d ~/.cache/Local/local-tmp-folder ]; then
  mkdir -p ~/.cache/Local/local-tmp-folder
fi
export TMPDIR="${HOME}/.cache/Local/local-tmp-folder"
alias bunx='bun x'
alias cat='bat --paging=never --style=grid'
alias cls=clear
#alias d='cd ~/dotfiles/'
alias d="cd $(dirname $(realpath $0))/.."
alias em='emacs -nw'
alias gp='git pull'
alias lg=lazygit
alias ll='eza -alhF --git --git-repos'
alias ls='eza -F'
alias lt='eza -T'
alias rmdir='rm -rf'
alias vi=nvim
alias ..='cd ../'
alias ...='cd ../../'
export AQUA_PROGRESS_BAR=true
source <(gh completion -s zsh)
source <(rye self completion -s zsh)
source <(uv generate-shell-completion zsh)
source <(uvx --generate-shell-completion zsh)
source <(podman completion zsh)
$(dirname $AQUA_GLOBAL_CONFIG)/update.sh
