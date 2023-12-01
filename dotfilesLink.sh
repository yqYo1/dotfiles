#!/bin/sh
CURRENT=$(cd $(dirname $0);pwd)
echo $CURRENT
ln -sf $CURRENT/zsh ~/.config/zsh
ln -sf $CURRENT/zsh/.zshrc ~/.zshrc
