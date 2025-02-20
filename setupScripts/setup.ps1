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
    #(Get-ItemProperty $destination).LinkTarget
  }else {
    New-Item -ItemType SymbolicLink -Path $destination -Value "$source"
  }
}

function Exist-Command($Name){
  Get-Command $Name -ErrorAction SilentlyContinue | Out-Null
  return($? -eq $true)
}


Push-Location -Path $PSScriptRoot

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
  #not admin
  git submodule update --init --recursive
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"

  # yaskkserv2
  # cargo install --git https://github.com/wachikun/yaskkserv2.git

  # aqua init
  ../aquaproj-aqua/update.ps1

  # bat
  bat cache --build

}else{
  #run admin

  #MSVC
  . ./BuildToolsSetup.ps1

  #CMake
  winget install --id Kitware.CMake

  #rust
  . ./rust.ps1

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
  makeSymbolickLink "$nvimDir\after" "$PSScriptRoot\..\nvim\after"

  #rye
  $ryeDir ="$env:USERPROFILE\.rye"
  makeSymbolickLink $ryeDir "$PSScriptRoot\..\rye"
  [Environment]::SetEnvironmentVariable("RYE_HOME", $ryeDir, 'User')
  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $newUserPath = ""
  if ( -not ($oldUsePath.Contains("$Env:RYE_HOME\shims"))){
    $newUserPath += "$Env:RYE_HOME\shims;"
  }
  if ($newUserPath){
    [System.Environment]::SetEnvironmentVariable("Path", ($newUserPath + $oldUsePath), "User")
    $Env:Path = ($newUserPath + $Env:Path)
  }

  #uv
  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $newUserPath = ""
  if ( -not ($oldUsePath.Contains("$Env:USERPROFILE\.local\bin"))){
    $newUserPath += "$Env:USERPROFILE\.local\bin;"
  }
  if ($newUserPath){
    [System.Environment]::SetEnvironmentVariable("Path", ($newUserPath + $oldUsePath), "User")
    $Env:Path = ($newUserPath + $Env:Path)
  }

  #LLVM
  winget install --id LLVM.LLVM
  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $newUserPath = ""
  if ( -not ($oldUsePath.Contains("C:\Program Files\LLVM\bin"))){
    $newUserPath += "C:\Program Files\LLVM\bin;"
  }
  if ($newUserPath){
    [System.Environment]::SetEnvironmentVariable("Path", ($newUserPath + $oldUsePath), "User")
    $Env:Path = ($newUserPath + $Env:Path)
  }

  #aqua
  $aquaRootDir = "$env:LOCALAPPDATA\aquaproj-aqua"
  makeDir $aquaRootDir
  [Environment]::SetEnvironmentVariable("AQUA_ROOT_DIR", $aquaRootDir, 'User')
  $Env:AQUA_ROOT_DIR = $aquaRootDir
  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $newUserPath = ""
  # if ( -not ($oldUsePath.Contains("$aquaRootDir\bat"))){
  #   $newUserPath += "$aquaRootDir\bat;"
  # }
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
  $aquaExe = (Get-ChildItem $env:LOCALAPPDATA\Microsoft\WinGet\Links\aqua.exe | Select-Object Target).Target
  Start-Process -FilePath $aquaExe -ArgumentList "i", "-a", "-l" -Wait -NoNewWindow
  Pop-Location

  #wezterm
  $weztermDir = "$dotConfig\wezterm"
  makeSymbolickLink $weztermDir "$PSScriptRoot\..\wezterm"
  winget install --id wez.wezterm

  #CorvusSKK
  $corvusskkDir = "$Env:APPDATA\CorvusSKK"
  makeSymbolickLink $corvusskkDir "$PSScriptRoot\..\CorvusSKK"
  winget install --id nathancorvussolis.corvusskk

  #lazygit
  $lazygitDir = "$Env:LOCALAPPDATA\lazygit"
  makeSymbolickLink $lazygitDir "$PSScriptRoot\..\lazygit"

  #PowerShell
  $pwshDir = "$env:USERPROFILE\Documents\PowerShell"
  makeDir $pwshDir
  $pwshProfile = "$pwshDir\Profile.ps1"
  makeSymbolickLink $pwshProfile "$PSScriptRoot\..\PowerShell\Profile.ps1"
  #Install-Module -Name PSReadLine -AllowClobber -Force
  Install-Module -Name posh-git -Scope CurrentUser -Force

  #bat
  $batDir = "$Env:APPDATA\bat"
  makeDir $batDir
  makeSymbolickLink "$batDir\config" "$PSScriptRoot\..\bat\config"
  makeSymbolickLink "$batDir\themes" "$PSScriptRoot\..\bat-catppuccin\themes"

  Get-Command podman -ea SilentlyContinue | Out-Null
  if ($? -eq $true) { # コマンドが存在すれば
    Write-Output 'Success!'
  } else {            # コマンドが存在しなければ
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    winget install --id Redhat.Podman
    Start-Process -FilePath "C:\Program Files\RedHat\Podman\podman.exe" -ArgumentList "machine", "init" -Wait -NoNewWindow
  }

  winget install --id LuaLS.lua-language-server

  pause
}
Pop-Location
