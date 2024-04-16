# run as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
    . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
}else{
  winget install --id Kitware.CMake

  function makeDir($dir){
    if ( -not (Test-Path $dir)){
      New-Item $dir -ItemType Directory
    }
  }

  $pwshDir = "$env:USERPROFILE\Documents\PowerShell"
    makeDir $pwshDir
    $pwshProfile = "$pwshDir\Profile.ps1"
    if (Test-Path $pwshProfile) {
      if ((Get-ItemProperty $pwshProfile).Mode.Substring(0,1) -ne 'l'){
        Remove-Item $pwshProfile -Force
          New-Item -ItemType SymbolicLink -Path $pwshProfile -Value "$PSScriptRoot\PowerShell\Profile.ps1"
      }
    }else {
      New-Item -ItemType SymbolicLink -Path $pwshProfile -Value "$PSScriptRoot\PowerShell\Profile.ps1"
    }
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
    if (Test-Path $InitLua) {
      if ((Get-ItemProperty $InitLua).Mode.Substring(0,1) -ne 'l'){
        Remove-Item $InitLua -Force
          New-Item -ItemType SymbolicLink -Path $InitLua -Value "$PSScriptRoot\nvim\init.lua"
      }
    }else {
      New-Item -ItemType SymbolicLink -Path $InitLua -Value "$PSScriptRoot\nvim\init.lua"
    }
  if (Test-Path $nvimLuaDir) {
    if ((Get-ItemProperty $nvimLuaDir).Mode.Substring(0,1) -ne 'l'){
      Remove-Item $nvimLuaDir -Force  -Recurse
        New-Item -ItemType SymbolicLink -Path $nvimLuaDir -Value "$PSScriptRoot\nvim\lua"
    }
  }else {
    New-Item -ItemType SymbolicLink -Path $nvimLuaDir -Value "$PSScriptRoot\nvim\lua"
  }
  pause
}
