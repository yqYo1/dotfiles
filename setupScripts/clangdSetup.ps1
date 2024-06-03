if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
  Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs -Wait
}else{
  function repover {
    param (
      [Alias('u')]
      [string]$author,
      [Alias('r')]
      [string]$repo
    )

    $content = (Invoke-WebRequest -Uri $('https://api.github.com/repos/{0}/{1}/releases/latest' -f $author, $repo) -UseBasicParsing -SkipHttpErrorCheck).Content | ConvertFrom-Json

    if ($content.PSObject.Properties.Name -contains 'tag_name') {
      return $content.tag_name
    }

    $content = (Invoke-WebRequest -Uri $('https://api.github.com/repos/{0}/{1}/tags' -f $author, $repo) -UseBasicParsing -SkipHttpErrorCheck).Content | ConvertFrom-Json

    if ($content.PSObject.Properties.Value -contains 'name') {
      return $content.name | Sort-Object -Descending -Unique | Select-Object -First 1
    }
  }
  $ClangdVer = repover -author clangd -repo clangd
    Write-Output $ClangdVer
    Invoke-WebRequest "https://github.com/clangd/clangd/releases/download/$ClangdVer/clangd-windows-$ClangdVer.zip" -OutFile clangd.zip
    Expand-Archive -Path .\clangd.zip -DestinationPath .\clangd
    if (Test-Path -Path "C:\clangd"){
      Remove-Item "C:\clangd" -Recurse -Force
    }
  Move-Item -Path ".\clangd\clangd_$ClangdVer" -Destination "C:\clangd"
  Remove-Item .\clangd.zip
  Remove-Item .\clangd -Recurse

  $oldUsePath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $newUserPath = ""
  if ( -not ($oldUsePath.Contains("C:\clangd\bin"))){
    $newUserPath += "C:\clangd\bin;"
  }
  if ($newUserPath){
    [System.Environment]::SetEnvironmentVariable("Path", ($newUserPath + $oldUsePath), "User")
    $Env:Path = ($newUserPath + $Env:Path)
  }
}
