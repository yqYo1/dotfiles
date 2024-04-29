Set-Alias ls eza
Set-Alias vi nvim
Set-PSReadLineOption -PredictionSouce HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Invoke-Expression (&starship init powershell)
