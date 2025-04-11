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
if ( ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators") ){
  throw "Running with administrator. Do not run with administrator."
}

# main

$PathChanged = $false
$Path = [System.Environment]::GetEnvironmentVariable("Path", "User")

# scoop
if (!(Exist-Command scoop)) {
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}else{
  echo "scoop is already installed"
}
[void]($applist = scoop list | Select-Object -ExpandProperty Name)
# foreach ($app in $applist) {
#   if ($app -ne "aqua") {
#     echo "update $app"
#     scoop update $app
#   }
# }
scoop update *
if (-not $applist.Contains("aria2")) {
  scoop install aria2
  scoop config aria2-warning-enabled false
}
if (-not $applist.Contains("7zip")) {
  scoop install 7zip
}
if (-not $applist.Contains("innounp")) {
  scoop install innounp
}
if (-not $applist.Contains("dark")) {
  scoop install dark
}
if (-not $applist.Contains("lua-language-server")) {
  scoop install lua-language-server
}
if (-not $applist.Contains("bun")) {
  scoop install bun
}

if (-not ($Path.Contains("$Env:USERPROFILE\bin"))){
  makeDir $HOME\bin
  Write-Host "add $Env:USERPROFILE\bin to Path"
  $PathChanged = $true
  $Path = "$Env:USERPROFILE\bin;$Path"
  $Env:PATH = "$Env:USERPROFILE\bin;$Path"
}

$aqua_bin_path = "$Env:USERPROFILE\bin\aqua.exe"
if (-not (Test-Path $aqua_bin_path)) {
  curl -sSLO "https://github.com/aquaproj/aqua/releases/latest/download/aqua_windows_amd64.zip"
  makeDir "aquabin"
  Set-Location .\aquabin
  tar -xf ..\aqua_windows_amd64.zip
  Set-Location ..
  Copy-Item -Path aquabin\aqua.exe -Destination $aqua_bin_path
  Remove-Item -Path aquabin -Recurse -Force
  Remove-Item -Path aqua_windows_amd64.zip -Force
}
# Start-Process -FilePath $aqua_bin_path -ArgumentList "i", "-a", "-l" -Wait -NoNewWindow

if ($PathChanged) {
  [System.Environment]::SetEnvironmentVariable("Path", $Path, "User")
}

bat cache --build
