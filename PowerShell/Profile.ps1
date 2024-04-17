$ENV:STARSHIP_CONFIG = "$env:USERPROFILE\.config/starship.toml"
Set-Alias ls eza
Set-Alias vi nvim
Invoke-Expression (&starship init powershell)
