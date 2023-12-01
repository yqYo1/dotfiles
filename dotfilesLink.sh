#!/bin/sh
CURRENT=$(cd $(dirname $0);pwd)
ln -sf $CURRENT/zsh ~/.config/zsh
ln -sf $CURRENT/zsh/.zshrc ~/.zshrc
ln -sf $CURRENT/starship.toml ~/.config/starship.toml
