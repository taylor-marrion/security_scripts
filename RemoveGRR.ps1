# Uninstall GRR

Set-ExecutionPolicy Unrestricted -Force

Start-Service "grr monitor"
Stop-Service "grr monitor"
#this nect line is a legit cmdlet, but not found on this particular system.
Remove-Service "grr monitor"
Remove-Item -Path "HKLM:\SOFTWARE\GRR" -Recurse
Get-ChildItem C:\Windows\system32\GRR -Recurse | Remove-Item -Force
Get-ChildItem C:\GRR_Installer.exe | Remove-Item -Force