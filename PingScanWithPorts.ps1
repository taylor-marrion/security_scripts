Set-ExecutionPolicy Unrestricted

#ping scan
$IP_array = @()
1..254 | foreach {
    $IP = "192.168.13.$_"
    if ($(Test-Connection -ComputerName $IP -Count 1 -Quiet)) {
        $IP_array += $IP
        Write-Host "$IP is pingable."
    }
}
Write-Host $IP_array.Count

#port scans
foreach ($IP in $IP_array) {
    if ($(Test-NetConnection -Port 443 -InformationLevel Quiet $IP)) {
        Write-Host "$IP has port 443 open."
    }
}

foreach ($IP in $IP_array) {
    if ($(Test-NetConnection -Port 1434 -InformationLevel Quiet $IP)) {
        Write-Host "$IP has port 1434 open."
    }
}
