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

if (!(Exist-Command aria2c)) {
  scoop install aria2
  scoop config aria2-warning-enabled false
}else{
  echo "aria2 is already installed"
}

if (!(scoop list | Select-String 7zip)){
  scoop install 7zip
}else{
  echo "7zip is already installed"
}

if (!(scoop list | Select-String innounp)){
  scoop install innounp
}else{
  echo "innounp is already installed"
}

if (!(scoop list | Select-String dark)){
  scoop install dark
}else{
  echo "dark is already installed"
}

if (!(scoop list | Select-String lua-language-server)){
  scoop install lua-language-server
}else{
  echo "lua-language-server is already installed"
}

if (!(scoop list | Select-String bun)){
  scoop install bun
}else{
  echo "bun is already installed"
}
