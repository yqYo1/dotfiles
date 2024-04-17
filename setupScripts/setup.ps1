Push-Location -Path $PSScriptRoot
# run as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
}else{
  function makeDir($dir){
    if ( -not (Test-Path $dir)){
      New-Item $dir -ItemType Directory
    }
  }
  function makeSymbolickLink($destination, $source){
    if (Test-Path $destination) {
      if ((Get-ItemProperty $destination).Mode.Substring(0,1) -ne 'l'){
        Remove-Item $destination -Force  -Recurse
        New-Item -ItemType SymbolicLink -Path $destination -Value "$source"
      }
    }else {
      New-Item -ItemType SymbolicLink -Path $destination -Value "$source"
    }
  }

  #install MSVC
  . ./BuildToolsSetup.ps1
  #install CMake
  winget install --id Kitware.CMake

  $dotConfig = "$env:USERPROFILE/.config"
  makeDir $dotConfig
  makeSymbolickLink "$dotConfig/starship.toml" "$PSScriptRoot/../starship.toml"

  $pwshDir = "$env:USERPROFILE\Documents\PowerShell"
  makeDir $pwshDir
  $pwshProfile = "$pwshDir\Profile.ps1"
  makeSymbolickLink $pwshProfile "$PSScriptRoot\..\PowerShell\Profile.ps1"
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"

    Get-Command aqua -ea SilentlyContinue | Out-Null
    if ( $? -eq $true ) {
      Write-Output 'Success!'
    } else {
      Write-Error 'Error!'
    }

  $nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
  makeDir $nvimDir
  $InitLua = "$nvimDir\init.lua"
  $nvimLuaDir = "$nvimDir\lua"
  makeSymbolickLink $InitLua "$PSScriptRoot/../nvim/init.lua"
  makeSymbolickLink $nvimLuaDir "$PSScriptRoot/../nvim/lua"

  pause
}
Pop-Location
