Set-Alias -Name ls -Value eza
Function ll {eza -alhF --git --git-repos}
Set-Alias -Name which -Value where.exe
Set-Alias -Name vi -Value nvim
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git
Invoke-Expression (&starship init powershell)
