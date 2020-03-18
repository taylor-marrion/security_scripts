<#
.SYNOPSIS
    Name: Compare_Enumerations.ps1
    The purpose of this script is to compare two previous enumerations.

.DESCRIPTION
    This script reads two input .txt files and outputs all differences between the two files.
    
.INPUT
    $refObject -> the filepath of the reference baseline enumeration
    $difObject -> the filepath of the enumeration being compared
    $output -> the filepath of the comparison output

.OUTPUT
    .txt file stored in <$output>

.NOTES
    Author:        Taylor Marrion
    Creation Date: 01-24-2019

#>

# Prompt user for baseline filepath
$refObject = Read-Host "Enter filepath of baseline enumeration"

# Prompt user for filepath of enumeration to be compared
$difObject = Read-Host "Enter filepath of enumeration to be compared"

# Prompt user for output filepath
$output = Read-Host "Enter filepath to store comparison results"

# break up commands for readability

# initialize variables
$ref = Get-Content $refObject
$dif = Get-Content $difObject
$results = Compare-Object -ReferenceObject ($ref) -DifferenceObject ($dif)
$results | Out-File -FilePath $output

<# end #>