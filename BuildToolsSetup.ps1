# run as admin
if (
  !(
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole("Administrators")){
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
}else{
  Invoke-webRequest "https://aka.ms/vs/17/release/vs_BuildTools.exe" -OutFile "vs_BuildTools.exe"
  Start-Process vs_BuildTools.exe "--passive --config `"$PSScriptRoot\minimum.vsconfig`"" -Wait
  Remove-Item .\vs_BuildTools.exe
  <#
  C:\msys64\usr\bin\bash -lc ' '
  C:\msys64\usr\bin\bash -lc 'pacman --noconfirm -Syuu'
  C:\msys64\usr\bin\bash -lc 'pacman --noconfirm -Syuu'

  [System.Environment]::SetEnvironmentVariable("MSYSTEM", "MINGW64", "Machine")
  $oldpath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  $newpath = ""
  if ( -not ($oldpath.Contains("C:\msys64\mingw64\bin"))){
    $newpath += ";C:\msys64\mingw64\bin"
  }
  if ( -not ($oldpath.Contains("C:\msys64\usr\local\bin"))){
    $newpath += ";C:\msys64\usr\local\bin"
  }
  if ( -not ($oldpath.Contains("C:\msys64\usr\bin"))){
    $newpath += ";C:\msys64\usr\bin"
  }
  if ( -not ($oldpath.Contains("C:\msys64\bin"))){
    $newpath += ";C:\msys64\bin"
  }
  if ( -not ($oldpath.Contains("C:\msys64\opt\bin"))){
    $newpath += ";C:\msys64\opt\bin"
  }
  if ($newpath){
    Write-Output $newpath
    $oldpath += $newpath
    [System.Environment]::SetEnvironmentVariable("Path", $oldpath, "Machine")
    $oldpath = $ENV:Path
    $Env:Path += $newpath
  }
  #>
}
pause
