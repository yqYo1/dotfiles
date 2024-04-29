Set-Alias ls eza
Set-Alias vi nvim
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Import-Module posh-git
Invoke-Expression (&starship init powershell)
