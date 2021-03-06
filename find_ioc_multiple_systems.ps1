#Set-ExecutionPolicy Unrestricted
#Enable-PSSessionConfiguration -Force
#Enable-PSRemoting -Force

# Note: RDP works
# Note: Look at box 17

#$targets = "192.168.13.133","192.168.13.145","192.168.13.240","192.168.13.200","10.0.0.02","10.0.0.04","172.16.8.13","172.16.8.14","172.16.8.15","172.16.8.17","172.16.8.18","172.16.8.19"
#$targets = "172.16.8.13","172.16.8.14","172.16.8.15","172.16.8.17","172.16.8.18","172.16.8.19"
$targets = @("172.16.8.17")
#$ioc = "virusdefender.org"

# IOC's
$apt28_dns_ioc = @("aljazeera-news.com","ausameetings.com","bbc-press.org","cnnpolitics.eu","dailyforeignnews.com","dailypoliticsnews.com","defenceiq.us","defencereview.eu","diplomatnews.org","euronews24.info","euroreport24.com","kg-news.org","military-info.eu","militaryadviser.org","militaryobserver.net","nato-hq.com","nato-news.com","natoint.com","natopress.com","osce-info.com","osce-press.org","pakistan-mofa.net","politicalreview.eu","politicsinform.com","reuters-press.com","shurl.biz","stratforglobal.net","thediplomat-press.com","theguardiannews.org","trend-news.org","unian-news.info","unitednationsnews.eu","virusdefender.org","worldmilitarynews.org","worldpoliticsnews.org","worldpoliticsreviews.com","worldpostjournal.com")
$apt28_2_dns_ioc = @("swsupporttools.com","www.capisp.com","www.dataclen.org","www.mscoresvw.com","www.windowscheckupdater.net","www.acledit.com","www.biocpl.org","www.wscapi.com","www.tabsync.net","www.storsvc.org","www.winupdatesysmic.com")

$apt28_rtf_file_ioc = @("Exercise_Noble_Partner_16.rtf","Iran_nuclear_talks.rtf","Putin_Is_Being_Pushed_to_Prepare_for_War.rtf","Statement by the Spokesperson of European Union on the latest developments in eastern Ukraine.rtf")
$apt28_binary_file_ioc = @("amdcache.dll","api-ms-win-core-advapi-l1-1-0.dll","api-ms-win-downlevel-profile-l1-1-0.dll","api-ms-win-samcli-dnsapi-0-0-0.dll","apisvcd.dll","btecache.dll","cormac.mcr","csrs.dll csrs.exe","decompbufferrawfix-0x624-1643712-1.dll","decompbufferrawpe-0x7c4-1429488-1.bin","hazard.exe","hello32.dll","hpinst.exe","iprpp.dll","lsasrvi.dll","mgswizap.dll","runrun.exe","vmware_manager.exe")
$apt28_temp_file_ioc = @("jhuhugit.temp","jhuhugit.tmp","jkeyskw.temp")

$apt2_reg_ioc = "HKCU\Software\Microsoft\Office test\Special\Perf"

$user = "administrator"
$pass = ConvertTo-SecureString -AsPlainText -Force -String P@ssw0rd
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$pass

$outfile = 'C:\Users\john.doe\Desktop\results.txt'
Get-Date > $outfile

foreach ($IP in $targets) {
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $IP -Force -Concatenate
    $session = New-PSSession -ComputerName $IP -Credential $cred
    Write-Host "$IP results:"

    
    Write-Host ""
    Write-Host "Sedkit DNS:"
    foreach ($ioc in $apt28_dns_ioc) {
        Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | ForEach-Object {if($_ -like $using:ioc) {Write-Host "$_ IOC DNS found" -ForegroundColor Cyan}}}
        Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | Where-Object {$_ -like $using:ioc} }
    }
    Write-Host $single_break

    Write-Host ""
    Write-Host "C&C DNS:"
    foreach ($ioc in $apt28_2_dns_ioc) {
        Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | ForEach-Object {if($_ -like $using:ioc) {Write-Host "$_ IOC DNS found" -ForegroundColor Cyan}}}
        Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | Where-Object {$_ -like $using:ioc} }
        $testvar = "time.windows.com"
        #Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | ForEach-Object {if($_ -match $testvar) {Write-Host "$_ IOC DNS found" -ForegroundColor Cyan}}}
        #Invoke-Command -Session $session -ScriptBlock {(Get-DnsClientCache).Name | Where-Object {$_ -like $using:ioc} }
    }
    Write-Host $single_break

    Write-Host ""
    Write-Host "rtf Files:"
    Invoke-Command -Session $session -ScriptBlock {Get-ChildItem -Path 'C:\' -Force -Include $using:apt28_rtf_file_ioc -Recurse -ErrorAction SilentlyContinue | ForEach-Object {Write-Host "$_" -ForegroundColor Cyan}}
    Write-Host $single_break

    Write-Host ""
    Write-Host "binary Files:"
    Invoke-Command -Session $session -ScriptBlock {Get-ChildItem -Path 'C:\' -Force -Include $using:apt28_binary_file_ioc -Recurse -ErrorAction SilentlyContinue | ForEach-Object {Write-Host "$_" -ForegroundColor Cyan}}
    Write-Host $single_break

    Write-Host ""
    Write-Host "temp Files:"
    Invoke-Command -Session $session -ScriptBlock {Get-ChildItem -Path $env:TEMP -Force -Include $using:apt28_temp_file_ioc -Recurse -ErrorAction SilentlyContinue | ForEach-Object {Write-Host "$_" -ForegroundColor Cyan}}
    Write-Host $single_break



    
    Write-Host "========================================================================================"
    

    Remove-PSSession $session
}


<#
$test = 
foreach ($IP in $remotable) {
    Write-Host "$IP results:"
    Enter-PSSession -ComputerName $IP -Credential $cred
    #Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Office test\Special"
    Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\"
    #(Get-DnsClientCache).Name | Where-Object {$apt28_dns_ioc -ccontains $_}
    #(Get-DnsClientCache).Name | Where-Object {$_ -like "virusdefender.org"}
    #(Get-NetTCPConnection).RemoteAddress
    Write-Host "=========="
    Exit-PSSession
}
$test
#>

<#
$IP = "172.16.8.17"
Write-Host "$IP results:"
Enter-PSSession -ComputerName $IP -Credential $cred
#Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Office test\Special"

Get-Item -Path "HKCU:\SOFTWARE\Microsoft\"
Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\"
Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\"

(Get-NetTCPConnection) | sort
Write-Host "=========="
Exit-PSSession
#>


<#
#"$IP results:" >> $outfile
    $session = New-PSSession -ComputerName "172.16.8.19" -Credential $cred
    #"DNS:" >> $outfile
    foreach ($ioc in $apt28_dns_ioc) {
        Invoke-Command -Session $session -ScriptBlock{(Get-DnsClientCache).Name | Where-Object {$_ -like $using:ioc} } >>$outfile
        #Invoke-Command -Session $session -ScriptBlock{(Get-DnsClientCache).Name} -ErrorAction SilentlyContinue
    }
    foreach ($ioc in $apt28_2_dns_ioc) {
        Invoke-Command -Session $session -ScriptBlock{(Get-DnsClientCache).Name | Where-Object {$_ -like $using:ioc} } >>$outfile
        #Invoke-Command -Session $session -ScriptBlock{(Get-DnsClientCache).Name} -ErrorAction SilentlyContinue
    }

    #"======================" >> $outfile
    Write-Host "======================"
    #>
