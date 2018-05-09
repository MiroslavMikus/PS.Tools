# Miroslav Mikus 2018/03/04
# 
# This script loops trought all children folders
# and creates list git remote URL's.
# 

param([Parameter(Mandatory=$true)][string]$searchDir,
      [Parameter(Mandatory=$false)][string]$outputDir,
      [Parameter(Mandatory=$false)][bool]$addHeader = $true)

# test input
# $outputDir="C:\Users\miros\OneDrive\Automation\PS"
# $outputDir=""
# $searchDir="C:\Users\miros\OneDrive\Automation\PS"

if(!(Test-Path $searchDir)){
    return;
}

Write-Host "Root directory: $searchDir"

$searchDirObject = Get-Item -Path $searchDir -Verbose # change path to object

if($outputDir -eq ""){
    $outputDir = $searchDir
}

$outputDirObject = Get-Item -Path $outputDir -Verbose # change path to object

Write-Host "Output directory: $outputDirObject"

$logFile = "$($outputDirObject.FullName)\_GitRemoteList_$($searchDirObject.Name).txt"

Write-Host "Path to log file: $logFile"

if(Test-Path $logFile){

    Remove-Item $logFile

    Write-Host "Old log file was deleted: $logFile"
}

if($addHeader){

    "# " + (Get-Date) | Out-File $logFile -Append

    Write-Host "Log file was created: $logFile"

    "# Root dir: $($searchDirObject.FullName)" | Out-File $logFile -Append
}    


$folders = Get-ChildItem -Path $searchDirObject.FullName | Where-Object{ $_.PSIsContainer }

foreach($folder in $folders)
{
    Set-Location $folder.FullName

    git config --get remote.origin.url | Out-File $logFile -Append
}

Start-Process $logFile

Read-Host -Prompt "Done - Press Enter to exit"
