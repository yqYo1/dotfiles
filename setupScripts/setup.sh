#!/bin/bash
XDG_CONFIG_HOME="$HOME/.config"
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.0/aqua-installer | bash
CURRENT=$(cd $(dirname $0);pwd)
ln -sfnvi $CURRENT/../zsh $XDG_CONFIG_HOME/zsh
ln -sfnvi $CURRENT/../zsh/.zshrc $HOME/.zshrc
ln -sfnvi $CURRENT/../starship.toml $XDG_CONFIG_HOME/starship.toml
ln -sfnvi $CURRENT/../nvim $XDG_CONFIG_HOME/nvim
ln -sfnvi $CURRENT/../aquaproj-aqua $XDG_CONFIG_HOME/aquaproj-aqua
ln -sfnvi $CURRENT/../rye $XDG_CONFIG_HOME/rye
#ln -sfnvi $CURRENT/../bun/package.json $HOME/package.json
#ln -sfnvi $CURRENT/../bun/bun.lockb $HOME/bun.lockb
