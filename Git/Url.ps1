# Miroslav Mikus 2018/03/04
# 
# This script loops trought all children folders
# and creates list git remote URL's.
# 

param([Parameter(Mandatory=$true)][string]$searchDir,
      [Parameter(Mandatory=$false)][string]$outputDir,
      [Parameter(Mandatory=$false)][bool]$addHeader = $true)

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

# test input
# $outputDir="C:\Users\miros\OneDrive\Automation\PS"
# $outputDir=""
# $searchDir="C:\Users\miros\OneDrive\Automation\PS"

if(!(Test-Path $searchDir)){

    Write-log "Search directory doesnt exist: $searchDir" -Path $logPath -Level Error
    
    Read-Host -Prompt "Press Enter to exit"
    
    return;
}

Write-log "Search directory: $searchDir" -Path $logPath

$searchDirObject = Get-Item -Path $searchDir -Verbose # change path to object

if($outputDir -eq ""){
    $outputDir = $searchDir
}

$outputDirObject = Get-Item -Path $outputDir -Verbose # change path to object

Write-log "Output directory: $outputDirObject" -Path $logPath

$logFile = "$($outputDirObject.FullName)\_GitRemoteList_$($searchDirObject.Name).txt"

Write-log "Path to log file: $logFile" -Path $logPath

if(Test-Path $logFile){

    Remove-Item $logFile

    Write-log "Old log file was deleted: $logFile" -Path $logPath -Level Warn
}

if($addHeader){

    "# " + (Get-Date) | Out-File $logFile -Append

    Write-log "Log file was created: $logFile" -Path $logPath

    "# Root dir: $($searchDirObject.FullName)" | Out-File $logFile -Append
}    

$folders = Get-ChildItem -Path $searchDirObject.FullName | Where-Object{ $_.PSIsContainer }

foreach($folder in $folders)
{
    Set-Location $folder.FullName

    git config --get remote.origin.url | Out-File $logFile -Append
}

Start-Process $logFile

Write-log "Done" -Path $logPath

Read-Host -Prompt "Press Enter to exit"
