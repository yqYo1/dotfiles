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

if (!(Exist-Command scoop)) {
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}else{
  echo "scoop is already installed"
}

[void]($applist = scoop list | Select-Object -ExpandProperty Name)
foreach ($app in $applist) {
  if ($app -ne "aqua") {
    echo "update $app"
    scoop update $app
  }
}

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
