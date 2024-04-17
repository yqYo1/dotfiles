# run as admin
if (
  !(
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole("Administrators")){
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
  # . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
}else{
  Invoke-webRequest "https://aka.ms/vs/17/release/vs_BuildTools.exe" -OutFile "vs_BuildTools.exe"
  Start-Process vs_BuildTools.exe "--passive --config `"$PSScriptRoot\setupScripts\minimum.vsconfig`"" -Wait
  Remove-Item .\vs_BuildTools.exe
}
#pause
