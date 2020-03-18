$pcap = Get-Content 'C:\Users\john.doe\Desktop\resolved.txt'

# These next lines aren't needed for this, but I'm keeping them for future reference
#$pcap | %{ $_.Split('')[1]; } > 'C:\Users\john.doe\Desktop\resolvedDomainOnly.txt'
#$pcapFiltered = Get-Content 'C:\Users\john.doe\Desktop\resolvedDomainOnly.txt'

$ioc = Get-Content 'C:\Users\john.doe\Desktop\apturls.txt'

foreach ($line in $ioc) {
    $pcap | Select-String $line
}