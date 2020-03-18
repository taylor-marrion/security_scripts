<#
	File: registryKeyComparison.ps1
	Author: Taylor Marrion
	Description: This script is used to compare Windows registry keys before and after running suspected malware.
#>

# user whose registry keys will be collected
$user = "john.doe"

# list of forensically relevant keys
$keylist ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce","HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce","HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks","HKLM:\SYSTEM\CurrentControlSet\SERVICES\","HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedUrls","HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\","HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

# create folders to store data, this will delete existing folders so it can be run repeatedly
Remove-Item -Path C:\Users\$user\Desktop\Registry -Recurse -ErrorAction SilentlyContinue
New-Item -Path C:\Users\$user\Desktop\ -Name Registry -ItemType "directory"
Remove-Item -Path C:\Users\$user\Desktop\Registry\Baselines -ErrorAction SilentlyContinue
New-Item -Path C:\Users\$user\Desktop\Registry -Name Baselines -ItemType "directory"
Remove-Item -Path C:\Users\$user\Desktop\Registry\Mal_Baselines -ErrorAction SilentlyContinue
New-Item -Path C:\Users\$user\Desktop\Registry -Name Mal_Baselines -ItemType "directory"

# create baseline
$i=1;foreach($_ in $keylist) {
    $file = "C:\Users\"+$user+"\Desktop\Registry\Baselines\"+$i+".txt"
    $_ | Out-File $file
    Get-Item -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    Get-ItemProperty -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    Get-ChildItem -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    $i++
}

# do bad stuff
Read-Host -Prompt "Run the bad stuff, then press enter. The un-bad stuff will run automatically later."

# re-create baselines after running malware
$i=1;foreach($_ in $keylist) {
    $file = "C:\Users\"+$user+"\Desktop\Registry\Mal_Baselines\"+$i+".txt"
    $_ | Out-File $file
    Get-Item -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    Get-ItemProperty -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    Get-ChildItem -Path $_ -ErrorAction SilentlyContinue | Out-File $file -Append
    $i++
}

# undo bad stuff
& "C:\Users\"+$user+"\Desktop\unbadv2.exe"

# compare baseline
$i=1;foreach($_ in $keylist) {
    $_ | Out-File C:\Users\$user\Desktop\Registry\Comparison.txt -append
    $baseline = Get-Content ("C:\Users\"+$user+"\Desktop\Registry\Baselines\"+$i+".txt")
    $mal = get-content ("C:\Users\"+$user+"\Desktop\Registry\Mal_Baselines\"+$i+".txt")
    $dif = Compare-Object -ReferenceObject $baseline -DifferenceObject $mal
    $dif | Out-File C:\Users\$user\Desktop\Registry\Comparison.txt -append
    $i++
}

