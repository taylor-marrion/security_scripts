<#
.SYNOPSIS
    Name: Enumerate_Baseline.ps1
    The purpose of this script is to create an enumeration of a system.

.DESCRIPTION
    This script enumerates information about the host system and outputs to a .txt file.
    Information Enumerated includes system date and time, hostname, users, groups,
    logged on users, running processes, services and their states, network information,
    listening network sockets, system configuration information, mapped drives, plug and
    play devices, shared resources, and scheduled tasks.
    
.INPUT
    $output -> the filepath of the enumeration output

.OUTPUT
    .txt file stored in <$output>

.NOTES
    Author:        Taylor Marrion
    Creation Date: 01-24-2019

#>

# create boolean to repeat script, initialize as true
$again = 'y'

 while ($again -ne 'n')
 {
# Prompt user for output filepath
$output = Read-Host "Enter filepath to store enumeration"

# System date and time
$datetime = "Date/Time: " + (Get-Date)
$datetime | Out-File -FilePath $output

#spacing for readability
"" | Out-File -FilePath $output -Append

# Hostname
("Hostname: " + (Get-Content env:computername)) | Out-File -FilePath $output -Append

#spacing for readability
"" | Out-File -FilePath $output -Append

# Users
"Local users:"  | Out-File -FilePath $output -Append
Get-LocalUser | Out-File -FilePath $output -Append

# Groups
"Local groups:"  | Out-File -FilePath $output -Append
Get-LocalGroup | Out-File -FilePath $output -Append

# Logged on users
"Logged on users:" | Out-File -FilePath $output -Append
query user | Out-File -FilePath $output -Append

#spacing for readability
"" | Out-File -FilePath $output -Append

# Running processes
"Running Processes:" | Out-File -FilePath $output -Append
Get-Process | Out-File -FilePath $output -Append

# Services and their states
"Services and their states:" | Out-File -FilePath $output -Append
Get-Service | Out-File -FilePath $output -Append

# Network information
"Network information:" | Out-File -FilePath $output -Append
Get-NetAdapter | Format-List | Out-File -FilePath $output -Append

# Listening network sockets
"Listening network sockets:" | Out-File -FilePath $output -Append
Get-NetTCPConnection -State Listen | Format-List | Out-File -FilePath $output -Append

# System configuration information
"System configuration information:" | Out-File -FilePath $output -Append
systeminfo | Out-File -FilePath $output -Append

#spacing for readability
"" | Out-File -FilePath $output -Append

# Mapped drives
"Mapped drives:" | Out-File -FilePath $output -Append
Get-PSDrive | Out-File -FilePath $output -Append

# Plug and play devices
"Plug and play devices:" | Out-File -FilePath $output -Append
Get-PnpDevice | Out-File -FilePath $output -Append

# Shared resources
"Shared resources:" | Out-File -FilePath $output -Append

"     SMB shares:" | Out-File -FilePath $output -Append
Get-SmbShare | Out-File -FilePath $output -Append

"     Printers:" | Out-File -FilePath $output -Append
Get-Printer | Out-File -FilePath $output -Append

# Scheduled tasks
"Scheduled tasks:" | Out-File -FilePath $output -Append
Get-ScheduledTask | Format-List | Out-File -FilePath $output -Append

$again = Read-Host "Complete another enumeration? (y/n)"
while (($again -ne 'y') -and ($again -ne 'n')) {$again = Read-Host "Complete another enumeration? (y/n)"}
#if ($again -ne 'y') then 

}

Write-Host "Goodbye!"

<# end #>

#C:\Users\Teebs\Desktop\test\test.txt
# Enumerate and compare can be done in one script. Something like "enter 1 to run enumeration, enter 2 to compare enumerations"