# Aliases
if( (Get-Alias cat).CommandType -eq "Alias" ){
  Remove-Item alias:cat -Force
}
Function cat {bat --paging=never --style=grid $args}
Function ls {eza -F $args}
Function lt {eza -T $args}
Function ll {eza -alhF --git --git-repos $args}
Function d {
  Push-Location ((Get-ItemProperty $PROFILE.CurrentUserAllHosts).ResolvedTarget | Split-Path | Split-Path)
}
Function .. {Set-Location "..\$args"}
Function ... {Set-Location "..\..\$args"}
Function .... {Set-Location "..\..\..\$args"}
if( (Get-Alias gp).CommandType -eq "Alias" ){
  Remove-Item alias:gp -Force
}
Function gp {git pull}
# Function pushd {Push-Location $args}
# Set-Alias -Name popd -Value Pop-Location
Set-Alias -Name which -Value where.exe
if( (Get-Alias where).CommandType -eq "Alias" ){
  Remove-Item alias:where -Force
}
Set-Alias -Name where -Value where.exe
Set-Alias -Name vi -Value nvim
Set-Alias -Name lg -Value Lazygit

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git

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
