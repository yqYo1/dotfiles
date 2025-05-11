$PathChanged = $false
$Path = [System.Environment]::GetEnvironmentVariable("Path", "User")
$IS_EXECUTED_FROM_IEX = ($null -eq $MyInvocation.MyCommand.Path)


# def
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


# main
Push-Location -Path $PSScriptRoot
if ( ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators") ){
  throw "Running with administrator. Do not run with administrator."
}


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
  "GCC",
  "bun",
  "ghq"
  "git",
  "llvm",
  "lua-language-server",
  "make",
  "nodejs-lts"
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


#ghq
if ($IS_EXECUTED_FROM_IEX -eq $true){
  ghq clone git@github.com:yqYo1/dotfiles.git
  ghq clone git@github.com:catppuccin/bat.git
}
$repo_list = @(
  "github.com/yqYo1/dotfiles",
  "github.com/catppuccin/bat"
)
$ghq_repo_path_list = ghq list
foreach ($repo_name in $repo_list){
  if ($ghq_repo_path_list -Contains $repo_name){
    Write-Host "$repo_name is already cloned"
  }else{
    Write-Host "$repo_name is not found"
    $repo_name = $repo_name.Replace("github.com/","git@github.com:")
    Write-Host "$repo_name"
    # ghq clone $repo_name
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
