#!/bin/sh
CURRENT=$(cd $(dirname $0);pwd)
ln -sf $CURRENT/zsh $XDG_CONFIG_HOME/zsh
ln -sf $CURRENT/zsh/.zshrc $HOME/.zshrc
ln -sf $CURRENT/starship.toml $XDG_CONFIG_HOME/starship.toml
ln -sf $CURRENT/nvim $XDG_CONFIG_HOME/nvim
ln -sf $CURRENT/aquaproj-aqua $XDG_CONFIG_HOME/aquaproj-aqua
ln -sf $CURRENT/rye $XDG_CONFIG_HOME/rye
