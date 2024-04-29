Set-Alias ls eza
Set-Alias vi nvim
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git
Invoke-Expression (&starship init powershell)
