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

# completions
[ -s "/home/yayoi/.bun/_bun" ] && source "/home/yayoi/.bun/_bun"
source <(gh completion -s zsh)
source <(rye self completion -s zsh)
source <(uv generate-shell-completion zsh)
source <(uvx --generate-shell-completion zsh)
source <(podman completion zsh)
source <(tailscale completion zsh)
source <(deno completion zsh)
source <(bat --completion zsh)

source <(zoxide init zsh)

if [[ -z "$LITELLM_API_KEY" ]]; then
  if [[ ! -e "$HOME/.zshenv" ]]; then
    touch ~/.zshenv
  fi
  if [[ -f "$HOME/.zshenv" ]]; then
    echo "export LITELLM_API_KEY=\"LITELLM_API_KEY\"" >> ~/.zshenv
  fi
fi
# $(dirname $AQUA_GLOBAL_CONFIG)/update.sh
function frepo(){
  # local GHQ_ROOT=$(ghq root)
  # local repo_dir=$(ghq list --full-path | fzf --preview "bat --color=always --style=header,grid --line-range :80 $GHQ_ROOT/{}/README.*")
  local repo_dir=$(ghq list --full-path | fzf --preview "bat --color=always --style=header,grid --line-range :80 {}/README.*")
  if [ -n "$repo_dir" ]; then
    cd $repo_dir
  fi
}
