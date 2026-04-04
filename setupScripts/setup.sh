#!/bin/env bash
DOTDIR=$(cd $(git rev-parse --show-toplevel);pwd)
cd $DOTDIR
XDG_CONFIG_HOME="$HOME/.config"
if [ ! -d $XDG_CONFIG_HOME ]; then
  mkdir $XDG_CONFIG_HOME
fi
git submodule update --init --recursive
ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
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
