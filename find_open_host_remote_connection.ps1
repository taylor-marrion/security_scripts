Set-ExecutionPolicy Unrestricted

Get-NetNeighbor -State Reachable

#ping sweep
$IParray = @()
1..15 | foreach {
    $IP = "10.10.10.$_"
    if ($(Test-Connection -ComputerName $IP -Count 1 -Quiet)) {
        $IParray += $IP
        Write-Host "$IP is pingable."
    }
}

#test for WinRM service
foreach ($IP in $IParray) {
    if ($(Test-WSMan -ComputerName $IP 2>$null)) {
        Write-Host "-----"
        Write-Host "$IP is remotable."
    }
}

#find open ports in target
$target = "10.10.10.14"
$ports = (21,22,23,80,139,443,445,5985,5986,8000,8080)
foreach ($port in $ports) {
    $socket = New-Object Net.Sockets.TcpClient
    $ErrorActionPreference = 'SilentlyContinue'
    $socket.Connect($target,$port) 2>$null
    $ErrorActionPreference = 'Continue'
    if ($socket.Connected) {
    "Port $port is open."
    $socket.Close()
    }
    $socket.Dispose()
    $socket=$null
}

#create and enter new session
Enable-PSSessionConfiguration
Enable-PSRemoting
New-PSSession
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 10.10.10.14
WinRM get winrm/config/client
Enter-PSSession 10.10.10.14
#dostuff

#exit session
Exit-PSSession
