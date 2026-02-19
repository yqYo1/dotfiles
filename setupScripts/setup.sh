#!/bin/env bash
DOTDIR=$(cd $(git rev-parse --show-toplevel);pwd)
ZSHRC="$DOTDIR/zsh/.zshrc"
cd $DOTDIR
XDG_CONFIG_HOME="$HOME/.config"
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
if [ ! -d $XDG_CONFIG_HOME ]; then
  mkdir $XDG_CONFIG_HOME
fi
git submodule update --init --recursive
ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
ln -sfnv $DOTDIR/git $XDG_CONFIG_HOME/git
ln -sfnv $DOTDIR/zsh $XDG_CONFIG_HOME/zsh
ln -sfnv $ZSHRC $HOME/.zshrc
ln -sfnv $DOTDIR/zsh/sheldon $XDG_CONFIG_HOME/sheldon
ln -sfnv $DOTDIR/starship.toml $XDG_CONFIG_HOME/starship.toml
ln -sfnv $DOTDIR/nvim $XDG_CONFIG_HOME/nvim
ln -sfnv $DOTDIR/aquaproj-aqua $XDG_CONFIG_HOME/aquaproj-aqua
ln -sfnv $DOTDIR/rye $XDG_CONFIG_HOME/rye
ln -sfnv $DOTDIR/wezterm $XDG_CONFIG_HOME/wezterm
ln -sfnv $DOTDIR/sway $XDG_CONFIG_HOME/sway
ln -sfnv $DOTDIR/tofi $XDG_CONFIG_HOME/tofi
ln -sfnv $DOTDIR/emacs $HOME/.emacs.d
if [ ! -d $XDG_CONFIG_HOME/bat ]; then
  mkdir $XDG_CONFIG_HOME/bat
fi
ln -sfnv $DOTDIR/bat/config $XDG_CONFIG_HOME/bat/config
ln -sfnv $DOTDIR/bat-catppuccin/themes $XDG_CONFIG_HOME/bat/themes
if type aqua > /dev/null 2>&1; then
  echo "aqua is already installed"
else
  echo "aqua not fuond"
  curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.4/aqua-installer | bash
fi
cd $DOTDIR/aquaproj-aqua
./update.sh

if type bun > /dev/null 2>&1; then
  echo "Bun is already installed"
  bun upgrade

  if grep -q "# bun completions" "$ZSHRC"; then
    echo "Cleaning up.zshrc after bun upgrade..."
    tmpfile="$(mktemp)"
    # "# bun completions" という行とその直後の1行を削除する
    # Bunのスクリプトは2行追加するため、計2行をスキップする
    awk '
      $0 == "# bun completions" { n=2; next }
      n > 0 { n--; next }
      { print }
    ' "$ZSHRC" > "$tmpfile" && mv "$tmpfile" "$ZSHRC"
    echo ".zshrc cleanup complete."
  fi
else
  echo "Bun not found"
  curl -fsSL https://bun.sh/install | bash
fi

if type rustup > /dev/null 2>&1; then
  echo "Rust is already installed"
  rustup self update
  rustup update stable
else
  echo "Rust not found"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
bat cache --build
if [[ -z "$LITELLM_API_KEY" ]]; then
  ZSHENV="$HOME/.zshenv"
  if [[ ! -e "$ZSHENV" ]]; then
    touch "$ZSHENV"
  fi
  if ! grep -q "skip_global_compinit=1" "$ZSHENV"; then
    echo "skip_global_compinit=1" >> "$ZSHENV"
  fi
  if ! grep -q "export LITELLM_API_KEY" "$ZSHENV"; then
    echo "export LITELLM_API_KEY=\"LITELLM_API_KEY\"" >> "$ZSHENV"
  fi
fi

$DOTDIR/setupScripts/completion_setup.zsh
