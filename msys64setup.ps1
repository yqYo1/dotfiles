# run as admin
if (
  !(
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole("Administrators")){
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
  . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
}else{

  Invoke-webRequest https://repo.msys2.org/distrib/msys2-x86_64-latest.exe -OutFile msys2.exe
  .\msys2.exe in --confirm-command --accept-messages --root C:/msys64
  Remove-Item .\msys2.exe

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
  C:\msys64\usr\bin\bash -lc 'pacman --noconfirm -Sy --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-gdb make'
}
pause
