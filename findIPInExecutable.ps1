Set-Location 'C:\Users\john.doe\Desktop\SysInternalsSuite'
$stringman = .\strings.exe 'C:\Users\john.doe\AppData\Local\Temp\ituneshelper.exe'
$stringman | Select-String -Pattern "(\d{1,3}\.){3}(\d{1,3})" | Sort-Object | Get-Unique

#both valid regex for IP's
#"((?:(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)\.){3}(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d))"
#"(\d{1,3}\.){3}(\d{1,3})"
