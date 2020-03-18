Set-ExecutionPolicy Unrestricted

$grr_user = 'admin'
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




# Ex 7.1-052


$user = "administrator"
$pass = ConvertTo-SecureString -AsPlainText -Force -String P@ssw0rd
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "administrator",$pass

$target = "172.16.12.15"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $target -Force
$session = New-PSSession -ComputerName $target -Credential $cred

#1 What is the kernel version of the windows server client?
Invoke-Command -Session $session -ScriptBlock {$(Get-ComputerInfo).OsVersion}

#2 On the Server Client, what is the last character of the MD5 hash for the file wdboot.sys?
Invoke-Command -Session $session -ScriptBlock {Get-ChildItem -Path c:\ -Filter "wdboot.sys" -Recurse -Force -ErrorAction SilentlyContinue}
Invoke-Command -Session $session -ScriptBlock {Get-FileHash -Path C:\Windows\System32\drivers\WdBoot.sys -Algorithm MD5}

#3 On the Server Client, what is the size of the hosts file?
Invoke-Command -Session $session -ScriptBlock {$(Get-Item C:\Windows\System32\Drivers\etc\hosts).Length}

#4
Invoke-Command -Session $session -ScriptBlock {Get-LocalUser | Format-Table}


Remove-PSSession $session