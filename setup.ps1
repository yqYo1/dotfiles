# run as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$pwshDir = "$env:USERPROFILE\Documents\PowerShell"
if (-not Test-Path $pwshDir){
  New-Item $pwshDir -ItemType Directory
}
$pwshProfile = "$pwshDir\Profile.ps1"
if (Test-Path $pwshProfile) {
  if ((Get-ItemProperty $pwshProfile).Mode.Substring(0,1) -ne 'l'){
    Remove-Item $pwshProfile -Force
    New-Item -ItemType SymbolicLink -Path $pwshProfile -Value $PSScriptRoot\PowerShell\Profile.ps1
  }
}else {
  New-Item -ItemType SymbolicLink -Path $pwshProfile -Value $PSScriptRoot\PowerShell\Profile.ps1
}

Get-Command aqua -ea SilentlyContinue | Out-Null
if ($? -eq $true) {
  Write-Output 'Success!'
} else {
  Write-Error 'Error!'
}

$nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
if (Test-Path $nvimDir) {
  if ((Get-ItemProperty $nvimDir).Mode.Substring(0,1) -ne 'l'){
    Remove-Item $nvimDir -Force -Recurse
    New-Item -ItemType SymbolicLink -Path $nvimDir -Value $PSScriptRoot\nvim
  }
}else {
  New-Item -ItemType SymbolicLink -Path $nvimDir -Value $PSScriptRoot\nvim
}
pause
