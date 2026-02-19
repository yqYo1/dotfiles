#!/bin/env zsh
DOTDIR=$(cd $(git rev-parse --show-toplevel);pwd)

starship init zsh > $DOTDIR/zsh/starship.zsh
ZSH_COMPLETION_DIR="$DOTDIR/zsh/completion"

if [ ! -d $ZSH_COMPLETION_DIR ]; then
  mkdir $ZSH_COMPLETION_DIR
fi

bat --completion zsh > $ZSH_COMPLETION_DIR/_bat
deno completions zsh > $ZSH_COMPLETION_DIR/_deno
gh completion -s zsh > $ZSH_COMPLETION_DIR/_gh
rye self completion -s zsh > $ZSH_COMPLETION_DIR/_rye
starship completions zsh > $ZSH_COMPLETION_DIR/_starship
uv generate-shell-completion zsh > $ZSH_COMPLETION_DIR/_uv
uvx --generate-shell-completion zsh > $ZSH_COMPLETION_DIR/_uvx
zoxide init zsh > $ZSH_COMPLETION_DIR/_zoxide

if (( $+commands[podman] )); then
  podman completion zsh > $ZSH_COMPLETION_DIR/_podman
fi
if (( $+commands[tailscale] ));then
  tailscale completion zsh > $ZSH_COMPLETION_DIR/_tailscale
fi

# compinit キャッシュの再生成（zsh-autocomplete が -C フラグで使用するため）
COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"
rm -f "$COMPDUMP" "$COMPDUMP.zwc"
export FPATH="$ZSH_COMPLETION_DIR:$FPATH"
autoload -Uz compinit && compinit -d "$COMPDUMP"
