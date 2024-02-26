alias ls=eza
alias cat=bat
alias vi=nvim
gh completion -s zsh >> $ZSHRC_DIR/completion/gh
rye self completion -s zsh > $ZSHRC_DIR/completion/rye
jj util completion --zsh > $ZSHRC_DIR/completion/jj
