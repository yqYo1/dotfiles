Get-Command cargo -ea SilentlyContinue | Out-Null
if ($? -eq $true) { # コマンドが存在すれば
  Write-Output "rust is already installed"
}else{
  Invoke-WebRequest "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" -OutFile "rustup-init.exe"
  Start-Process rustup-init.exe "-y" -Wait
  Remove-Item ".\rustup-init.exe"
}
