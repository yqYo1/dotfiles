$PathChanged = $false
$PathInit = $false
$IS_EXECUTED_FROM_IEX = ($null -eq $MyInvocation.MyCommand.Path)


# def
function makeDir($dir){
  if ( -not (Test-Path $dir)){
    New-Item $dir -ItemType Directory
  }
}

function makeSymbolickLink {
    param(
        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter(Mandatory)]
        [string]$Source
    )

    $item = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    $sourceFull = [System.IO.Path]::GetFullPath($Source)

    if ($null -ne $item) {
        $isSymbolicLink = ($item.PSObject.Properties.Name -contains 'LinkType') -and ($item.LinkType -eq 'SymbolicLink')

        if ($isSymbolicLink) {
            $currentTargetRaw = $null

            if (($item.PSObject.Properties.Name -contains 'LinkTarget') -and $item.LinkTarget) {
                $currentTargetRaw = $item.LinkTarget
            }
            elseif (($item.PSObject.Properties.Name -contains 'Target') -and $item.Target) {
                $currentTargetRaw = $item.Target
            }

            if ($currentTargetRaw -is [array]) {
                $currentTargetRaw = $currentTargetRaw[0]
            }

            $currentTargetFull = $null
            if ($currentTargetRaw) {
                if ([System.IO.Path]::IsPathRooted($currentTargetRaw)) {
                    $currentTargetFull = [System.IO.Path]::GetFullPath($currentTargetRaw)
                }
                else {
                    $baseDir = Split-Path -Parent $item.FullName
                    $currentTargetFull = [System.IO.Path]::GetFullPath((Join-Path $baseDir $currentTargetRaw))
                }
            }

            if ($currentTargetFull -ine $sourceFull) {
                Remove-Item -LiteralPath $Destination -Force
                New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
            }
        }
        else {
            Remove-Item -LiteralPath $Destination -Force -Recurse
            New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
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

winget install --id Microsoft.PowerShell --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity

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
  "deno",
  "GCC",
  "bun",
  "ghq"
  "git",
  "llvm",
  "lua-language-server",
  "make",
  "nodejs-lts",
  "tree-sitter",
  "npiperelay"
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

# $aqua_bin_path = "$Env:USERPROFILE\bin\aqua.exe"
# if (-not (Test-Path $aqua_bin_path)) {
#   curl -sSLO "https://github.com/aquaproj/aqua/releases/latest/download/aqua_windows_amd64.zip"
#   makeDir "aquabin"
#   Set-Location .\aquabin
#   tar -xf ..\aqua_windows_amd64.zip
#   Set-Location ..
#   Copy-Item -Path aquabin\aqua.exe -Destination $aqua_bin_path
#   Remove-Item -Path aquabin -Recurse -Force
#   Remove-Item -Path aqua_windows_amd64.zip -Force
# }

#TODO aqua init
$Env:AQUA_GLOBAL_CONFIG = Join-Path (& ghq root) "github.com/yqYo1/dotfiles/aquaproj-aqua/aqua.yaml"
aqua i -a
aqua upa

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

$dotConfig = "$env:USERPROFILE\.config"
$dotfiles = (ghq list --full-path --exact yqYo1/dotfiles)
makeDir $dotConfig

makeSymbolickLink "$Env:USERPROFILE\.gitconfig" "$dotfiles\git\config"
makeSymbolickLink "$Env:APPDATA\CorvusSKK" "$dotfiles\CorvusSKK"
makeSymbolickLink "$Env:APPDATA\bat\config" "$dotfiles\bat\config"
makeSymbolickLink "$Env:APPDATA\bat\themes" "$(ghq list --full-path --exact catppuccin/bat)/themes"
makeSymbolickLink "$Env:LOCALAPPDATA\aicommit2" "$dotfiles\aicommit2"
makeSymbolickLink "$Env:LOCALAPPDATA\lazygit" "$dotfiles\lazygit"
makeSymbolickLink "$Env:LOCALAPPDATA\nvim" "$dotfiles\nvim"
makeSymbolickLink "$dotConfig\aquaproj-aqua\aqua.yaml" "$dotfiles\aquaproj-aqua\aqua.yaml"
makeSymbolickLink "$dotConfig\starship.toml" "$dotfiles\starship.toml"
makeSymbolickLink "$dotConfig\wezterm" "$dotfiles\wezterm"
makeSymbolickLink "$env:USERPROFILE\Documents\PowerShell\Profile.ps1" "$dotfiles\PowerShell\Profile.ps1"

bat cache --build
Pop-Location
