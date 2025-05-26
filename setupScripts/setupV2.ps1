$PathChanged = $false
$PathInit = $false
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

function path_change_init(){
  $script:PathInit = $true
  $script:currentPathString = [System.Environment]::GetEnvironmentVariable("Path", "User")
  if ([string]::IsNullOrEmpty($script:currentPathString)) {
    $script:currentPathsArray = @()
  } else {
    # Pathを配列に分割し、各パスを正規化（末尾の '\' を削除）、空のエントリを除去
    $script:currentPathsArray = $script:currentPathString.Split(';') | ForEach-Object { $_.Trim().TrimEnd('\') } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
  }
}

function addPath($addPath){
  if (-not $script:PathInit){
    path_change_init
  }
  $pathAlreadyExists = $false
  $NormalizedAddPath = $addPath.TrimEnd('\')
  foreach ($path in $script:currentPathsArray) {
    if ($path.Equals($NormalizedAddPath, [System.StringComparison]::OrdinalIgnoreCase)){
      $pathAlreadyExists = $true
      break
    }
  }
  # if (-not ($Path -cmatch $path)){
  if (-not $pathAlreadyExists){
    Write-Host "add $addPath to User Path"
    $script:PathChanged = $true
    $script:currentPathString = "$addPath;$script:currentPathString"
    $Env:PATH = "$addPath;$Env:Path"
  }else{
    Write-Host "$addPath is already in Path"
  }
}

function applyPath(){
  if ($script:PathChanged) {
    [System.Environment]::SetEnvironmentVariable("Path", $script:currentPathString, "User")
    Write-Host "User Path is changed"
  }else{
    Write-Host "User Path is not changed"
  }
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
scoop cleanup *
foreach ($app in $applist) {
  if (-not ($installedApplist.Contains($app))) {
    Write-Host "install $app"
    scoop install $app
  }else{
    Write-Host "$app is already installed"
  }
}


#TODO ghwの管理下にないrepoを自動的にcloneする
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
    ghq clone $repo_name
  }
}

makeDir "$HOME\bin"
addPath "$Env:USERPROFILE\bin"

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

#TODO aqua init

addPath "$Env:USERPROFILE\.bun\bin"
applyPath

gh auth token 2>&1 > $null
if (-not $?){
  gh auth login -p ssh -h Github.com -w
}else{
    Write-Host "Github CLI is already logined"
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
