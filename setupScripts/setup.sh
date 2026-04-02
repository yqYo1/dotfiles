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
ln -sfnv $DOTDIR/wezterm $XDG_CONFIG_HOME/wezterm
ln -sfnv $DOTDIR/sway $XDG_CONFIG_HOME/sway
ln -sfnv $DOTDIR/tofi $XDG_CONFIG_HOME/tofi
ln -sfnv $DOTDIR/emacs $HOME/.emacs.d

if type nix > /dev/null 2>&1; then
  echo "Nix is already installed"
else
  echo "Nix not found"
  echo "Installing Nix..."
  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --extra-conf "extra-trusted-users = $(id -un)"
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix run .#switch

if type rustup > /dev/null 2>&1; then
  echo "Rust is already installed"
  rustup self update
  rustup update stable
else
  echo "Rust not found"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
