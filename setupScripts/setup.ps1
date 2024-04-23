# require develoopoer mode

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

  #starship
  $dotConfig = "$env:USERPROFILE\.config"
  makeDir $dotConfig
  [Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", "$dotConfig\starship.toml", 'User')
  makeSymbolickLink "$dotConfig\starship.toml" "$PSScriptRoot\..\starship.toml"

  #nvim
  $nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
  makeDir $nvimDir
  $InitLua = "$nvimDir\init.lua"
  $nvimLuaDir = "$nvimDir\lua"
  makeSymbolickLink $InitLua "$PSScriptRoot\..\nvim\init.lua"
  makeSymbolickLink $nvimLuaDir "$PSScriptRoot\..\nvim\lua"

  #rye
  $ryeDir ="$env:USERPROFILE\.rye"
  makeSymbolickLink $ryeDir "$PSScriptRoot\..\rye"

  #aqua
  $aquaRootDir = "$env:LOCALAPPDATA\aquaproj-aqua"
  makeDir $aquaRootDir
  [Environment]::SetEnvironmentVariable("AQUA_ROOT_DIR", $aquaRootDir, 'User')
  $Env:AQUA_ROOT_DIR = $aquaRootDir
  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  #[Environment]::SetEnvironmentVariable("AQUA_ROOT_DIR", "%LOCALAPPDATA%\aquaproj-aqua", 'User')
  $newUserPath = ""
  if ( -not ($oldUsePath.Contains("$aquaRootDir\bat"))){
    $newUserPath += "$aquaRootDir\bat;"
  }
  if ( -not ($oldUsePath.Contains("$aquaRootDir\bin"))){
    $newUserPath += "$aquaRootDir\bin;"
  }
  if ($newUserPath){
    [System.Environment]::SetEnvironmentVariable("Path", ($newUserPath + $oldUsePath), "User")
    $Env:Path = ($newUserPath + $Env:Path)
  }
  makeDir "$dotConfig\aquaproj-aqua"
  makeSymbolickLink "$dotConfig\aquaproj-aqua\aqua.yaml" "$PSScriptRoot\..\aquaproj-aqua\aqua.yaml"
  [Environment]::SetEnvironmentVariable("AQUA_GLOBAL_CONFIG", "$dotConfig\aquaproj-aqua\aqua.yaml", 'User')
  $Env:AQUA_GLOBAL_CONFIG = "$dotConfig\aquaproj-aqua\aqua.yaml"
  [Environment]::SetEnvironmentVariable("AQUA_PROGRESS_BAR", "true", 'User')
  $Env:AQUA_PROGRESS_BAR = "true"
  winget install --id aquaproj.aqua
  Push-Location -Path "$dotConfig\aquaproj-aqua"
  $env:LOCALAPPDATA\Microsoft\WinGet\Links\aqua.exe i -a -l
  Pop-Location

  #PowerShell
  $pwshDir = "$env:USERPROFILE\Documents\PowerShell"
  makeDir $pwshDir
  $pwshProfile = "$pwshDir\Profile.ps1"
  makeSymbolickLink $pwshProfile "$PSScriptRoot\..\PowerShell\Profile.ps1"
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"

  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  winget install --id Redhat.Podman
  $env:LOCALAPPDATA\Microsoft\WinGet\Links\podman.exe machine init

  pause
}
Pop-Location
