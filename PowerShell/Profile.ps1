Set-Alias -Name ls -Value eza
Function ll {eza -alhF --git --git-repos $args}
Function d {Set-Location "~\dotfiles\"}
Function .. {Set-Location "..\$args"}
Function ... {Set-Location "..\..\$args"}
Function .... {Set-Location "..\..\..\$args"}
if( (Get-Alias gp).CommandType -eq "Alias" ){
  Remove-Item alias:gp -Force
}
Function gp {git pull}
Set-Alias -Name which -Value where.exe
Set-Alias -Name vi -Value nvim
Set-Alias -Name lg -Value Lazygit

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git

$apikeyps1 = Join-Path (Split-Path -Parent $PROFILE) apikey.ps1
if(Test-Path $apikeyps1){
  . $apikeyps1
}
Remove-Variable apikeyps1

Invoke-Expression (&starship init powershell)
$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}
