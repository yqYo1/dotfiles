function Exist-Command($Name){
  Get-Command $Name -ErrorAction SilentlyContinue | Out-Null
  return($? -eq $true)
}
if (Exist-Command cargo) { # コマンドが存在すれば
  Write-Output "rust is already installed"
  rustup self update
  rustup update stable
}else{
  Invoke-WebRequest "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" -OutFile "rustup-init.exe"
  Start-Process rustup-init.exe "-y" -Wait
  Remove-Item ".\rustup-init.exe"
}
