#!/bin/bash
XDG_CONFIG_HOME="$HOME/.config"
if [ ! -d $XDG_CONFIG_HOME ]; then
	mkdir $XDG_CONFIG_HOME
fi
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer | bash
CURRENT=$(cd $(dirname $0);pwd)
ln -sfnv $CURRENT/../zsh $XDG_CONFIG_HOME/zsh
ln -sfnv $CURRENT/../zsh/.zshrc $HOME/.zshrc
ln -sfnv $CURRENT/../zsh/sheldon $XDG_CONFIG_HOME/sheldon
ln -sfnv $CURRENT/../starship.toml $XDG_CONFIG_HOME/starship.toml
ln -sfnv $CURRENT/../nvim $XDG_CONFIG_HOME/nvim
ln -sfnv $CURRENT/../aquaproj-aqua $XDG_CONFIG_HOME/aquaproj-aqua
ln -sfnv $CURRENT/../rye $XDG_CONFIG_HOME/rye
ln -sfnv $CURRENT/../wezterm $XDG_CONFIG_HOME/wezterm
ln -sfnv $CURRENT/../sway $XDG_CONFIG_HOME/sway
ln -sfnv $CURRENT/../tofi $XDG_CONFIG_HOME/tofi
#ln -sfnv $CURRENT/../bun/package.json $HOME/package.json
#ln -sfnv $CURRENT/../bun/bun.lockb $HOME/bun.lockb
curl https://sh.rustup.rs -sSf | sh
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
