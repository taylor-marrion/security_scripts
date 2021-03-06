#Set-ExecutionPolicy Unrestricted

# user
$user = "john.doe"

# find .zip and .rar files
$zipper = $(Get-ChildItem -Path 'C:\Users\'+$user+'\Documents' -Recurse -Filter "*.zip").FullName
$zcount = $($zipper).Count
$rarrer = $(Get-ChildItem -Path 'C:\Users\'+$user+'\Documents' -Recurse -Filter "*.rar").FullName
$rcount = $($rarrer).Count
$toatlfilescount = $zcount + $rcount
$toatlfilescount


# find files w/ ADS
$allfiles = Get-ChildItem -Path 'C:\Users\'+$user+'\Documents' -Recurse
$($allfiles).Count
$results = $allfiles | ForEach-Object {Get-Item $_.FullName -stream *} | where stream -NE ':$data';
$($results | Measure-Object).Count

#foreach ($i in $results) {$i.FileName}
$filenames = $($results).filename


# file extracted from DIR 1a
$($results).stream

Get-Item -Path 'C:\Users\'+$user+'\Documents\exercise_8\bqekifltpz\jodwsxfrti\ibdlcsoznj.txt' -Stream *
Get-Content -Path 'C:\Users\'+$user+'\Documents\exercise_8\bqekifltpz\jodwsxfrti\ibdlcsoznj.txt' -Stream swogrxkcbh > 'C:\Users\'+$user+'\Desktop\test'
Get-Content 'C:\Users\'+$user+'\Desktop\test'

# content of file
[IO.File]::WriteAllBytes('C:\Users\'+$user+'\Desktop\test6', (cat 'C:\Users\'+$user+'\Documents\exercise_8\bqekifltpz\jodwsxfrti\ibdlcsoznj.txt:swogrxkcbh' -Encoding Byte))
#rename file to ".rar" using gui
#right-click, extract to...

# file extracted from DIR 2
Get-Item -Path 'C:\Users\'+$user+'\Documents\exercise_8\sgtcpqbwzo\pqyuemditc.txt' -Stream *
Get-Content -Path 'C:\Users\'+$user+'\Documents\exercise_8\sgtcpqbwzo\pqyuemditc.txt' -Stream teoycsrwul > 'C:\Users\'+$user+'\Desktop\test'
Get-Content 'C:\Users\'+$user+'\Desktop\test'

# conetnt of file
[IO.File]::WriteAllBytes('C:\Users\'+$user+'\Desktop\test8', (cat 'C:\Users\'+$user+'\Documents\exercise_8\sgtcpqbwzo\pqyuemditc.txt:teoycsrwul' -Encoding Byte))
#rename file to ".pk" using gui
#right-click, extract to...

# file extracted from DIR 2
Get-Item -Path 'C:\Users\'+$user+'\Documents\exercise_8\sgtcpqbwzo\euxvzpoqdf\wfzardupoq.txt' -Stream *
Get-Content -Path 'C:\Users\'+$user+'\Documents\exercise_8\sgtcpqbwzo\euxvzpoqdf\wfzardupoq.txt' -Stream mltjcfwgbx > 'C:\Users\'+$user+'\Desktop\test'
Get-Content 'C:\Users\'+$user+'\Desktop\test'

# conetnt of file
Get-Content 'C:\Users\'+$user+'\Desktop\test'

# look for files missed my original search. Use file signature(s)
$txtfiles = Get-ChildItem -Path 'C:\Users\'+$user+'\Documents' -Recurse -Filter "*.txt"
$tcount = $($txtfiles).Count

$pk_array = @()
$rar_array = @()
foreach ($file in $txtfiles) {
    
    if (Format-Hex $file.FullName | Select-String -CaseSensitive "PK") {
        $pk_array += $file.FullName
    }
    if (Format-Hex $file.FullName | Select-String -CaseSensitive "Rar") {
        $rar_array += $file.FullName
    }
    
}
$pk_array.Count
$rar_array.Count