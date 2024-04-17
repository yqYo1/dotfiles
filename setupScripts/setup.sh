#!/bin/bash
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.0/aqua-installer | bash
CURRENT=$(cd $(dirname $0);pwd)
ln -sf $CURRENT/zsh $XDG_CONFIG_HOME/zsh
ln -sf $CURRENT/zsh/.zshrc $HOME/.zshrc
ln -sf $CURRENT/starship.toml $XDG_CONFIG_HOME/starship.toml
ln -sf $CURRENT/nvim $XDG_CONFIG_HOME/nvim
ln -sf $CURRENT/aquaproj-aqua $XDG_CONFIG_HOME/aquaproj-aqua
ln -sf $CURRENT/rye $XDG_CONFIG_HOME/rye
ln -sf $CURRENT/bun/package.json $HOME/package.json
ln -sf $CURRENT/bun/bun.lockb $HOME/bun.lockb
