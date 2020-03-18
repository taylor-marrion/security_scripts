﻿Set-ExecutionPolicy Unrestricted

$grr_user = 'admin'
# TODO collect password from user prompt
$grr_pass = 'P@ssw0rd'

$pair = "$($grr_user):$($grr_pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

#$ip = Read-Host -Prompt "Enter ip that you want to install GRR: "
$ip = '172.16.12.15'

if (Test-WSMan $ip) {
    Write-Host "$ip can remote to via PSSession" -ForegroundColor Green
    Set-Item WSMan:\localhost\Client\TrustedHosts $ip -Force -Concatenate 
}

Enable-PSSessionConfiguration

$break = "================================================================="
Write-Host "Remoting to $ip" -ForegroundColor Green
Write-Host $break -ForegroundColor Green

#login to remote ip
$PWord = ConvertTo-SecureString -AsPlainText -Force -String P@ssw0rd 
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "administrator",$PWord 

New-PSSession $ip -Credential $Credential
$session = Get-PSSession

#Invoke-Command -ComputerName $session.ComputerName -ScriptBlock { Enable-PSSessionConfiguration -Force; Enable-PSRemoting -Force }
Invoke-Command -ComputerName $session.ComputerName -Credential $Credential -ScriptBlock { cd $env:TEMP; Invoke-WebRequest -Uri 'http://172.16.12.12:8000/api/config/binaries/EXECUTABLE/windows/installers/GRR_3.2.0.0_amd64.exe' -Headers $using:Headers -OutFile grr_install.exe; Start-Process -FilePath ".\grr_install.exe"; Start-Sleep -Seconds 20 }
Invoke-Command -ComputerName $session.ComputerName -Credential $Credential -ScriptBlock { Stop-Service "GRR Monitor"; $ip_change = gc "C:\Windows\System32\GRR\3.2.0.0\GRR.exe.yaml" | Select-String -Pattern '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'; (gc -Path "C:\Windows\System32\GRR\3.2.0.0\GRR.exe.yaml" -Raw) -replace $ip_change, 'Client.server_urls: http://172.16.12.12:8080/' | Out-File "C:\Windows\System32\GRR\3.2.0.0\GRR.exe.yaml" ; Start-Sleep -Seconds 10; Start-Service "GRR Monitor"}


Remove-PSSession $ip
