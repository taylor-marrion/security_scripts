Set-ExecutionPolicy Unrestricted

#Find local IP
$local = $($(Get-NetIPConfiguration).IPv4Address).IPAddress

#ping sweep, excluding local IP address
$low = 1
$high = 107
$pingable = @()
$low..$high | foreach {
    $IP = "10.10.10.$_"

    # variables for write-progress
    $current = $_ - $low
    $range = $high -$low
    $percent = $current/$range*100
    Write-Progress -Activity "Scanning IP range" -Status "Scanning $IP" -PercentComplete $percent

    # if IP is pingable and not localhost
    if ($(Test-Connection -ComputerName $IP -Count 1 -Quiet)  -and $($IP -ne $local)) {
        $pingable += $IP
        Write-Host "$IP is pingable."
    }
}

#test for WinRM service
$remotable = @()
foreach ($IP in $pingable) {
    if ($(Test-WSMan -ComputerName $IP 2>$null)) {
        $remotable += $IP
        Write-Host "$IP is remotable."
    }
}

# Equivalent to above loop to find remotable hosts
#$sessions = @()
#$pingable | foreach {
#    if (Test-NetConnection $_ -p 5985 -i Quiet -WarningAction SilentlyContinue) {
#        $sessions += $_
#        Write-Host "$_ is remotable."
#    }
#}



#This next bit needs finessing
Enable-PSSessionConfiguration
Enable-PSRemoting

$cred = Get-Credential
foreach ($IP in $pingable) {
    New-PSSession -ComputerName $IP -Credential $cred
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $IP
    WinRM get winrm/config/client
    Enter-PSSession $IP
    #dostuff
    Exit-PSSession
}
