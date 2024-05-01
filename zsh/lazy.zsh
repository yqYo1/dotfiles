alias ls=eza
alias vi=nvim
source <(gh completion -s zsh)
source <(rye self completion -s zsh)
source <(jj util completion --zsh)
aqua update-aqua
export PATH="$HOME/.local/bin:$PATH"
