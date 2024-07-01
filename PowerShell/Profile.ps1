Set-Alias -Name ls -Value eza
Function ll {eza -alhF --git --git-repos $args}
Function d {Set-Location "~\dotfiles\"}
Function .. {Set-Location "..\$args"}
Function ... {Set-Location "..\..\$args"}
Function .... {Set-Location "..\..\..\$args"}
Remove-Item alias:gp -Force
Function gp {git pull}
Set-Alias -Name which -Value where.exe
Set-Alias -Name vi -Value nvim
Set-Alias -Name lg -Value Lazygit
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git
Invoke-Expression (&starship init powershell)
