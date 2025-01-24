#!/bin/env bash
DOTDIR=$(cd $(dirname $0)/..;pwd)
cd $DOTDIR
XDG_CONFIG_HOME="$HOME/.config"
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
if [ ! -d $XDG_CONFIG_HOME ]; then
  mkdir $XDG_CONFIG_HOME
fi
git submodule update --init --recursive
ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
ln -sfnv $DOTDIR/zsh $XDG_CONFIG_HOME/zsh
ln -sfnv $DOTDIR/zsh/.zshrc $HOME/.zshrc
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
#ln -sfnv $DOTDIR/bun/package.json $HOME/package.json
#ln -sfnv $DOTDIR/bun/bun.lockb $HOME/bun.lockb
if type aqua > /dev/null 2>&1; then
  echo "aqua is already installed"
else
  echo "aqua not fuond"
  curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer | bash
fi
cd $DOTDIR/aquaproj-aqua
./update.sh
# if [ -f $HOME/.cargo/env ]; then
#   echo "test"
#   source $HOME/.cargo/env
# fi
if type rustup > /dev/null 2>&1; then
  echo "Rust is already installed"
  rustup self update
  rustup update stable
else
  echo "Rust not found"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
bat cache --build
