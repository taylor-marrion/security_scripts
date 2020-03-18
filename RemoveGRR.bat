sc start "grr monitor"
sc stop "grr monitor"
sc delete "grr monitor"
#reg delete HKLM\Software\GRR
echo y | reg delete HKLM\Software\GRR
rmdir /Q /S c:\windows\system32\grr
del /F c:\windows\system32\grr_installer.txt
"C:\Users\john.doe\Desktop\verify.exe"