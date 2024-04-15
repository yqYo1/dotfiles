if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }


