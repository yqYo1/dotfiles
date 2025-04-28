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
[void]($installedApplist = scoop list | Select-Object -ExpandProperty Name)

$applist = @(
  "7zip",
  "innounp",
  "dark",
  "lua-language-server",
  "bun",
  "GCC",
  "llvm",
  "nodejs-lts",
  "git",
  "make"
)
scoop update *
foreach ($app in $applist) {
  if (-not ($installedApplist.Contains($app))) {
    Write-Host "install $app"
    scoop install $app
  }else{
    Write-Host "$app is already installed"
  }
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

if (-not (Get-PSRepository PSGallery | Select-Object -ExpandProperty Trusted)) {
  Write-Host "Trust PSGallery"
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$moduleList = Get-InstalledModule | Select-Object -ExpandProperty Name
if (-not $moduleList.Contains("git-completion")) {
  Install-Module git-completion
}

bat cache --build
Pop-Location
