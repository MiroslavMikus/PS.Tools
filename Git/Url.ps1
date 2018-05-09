# Miroslav Mikus 2018/03/04
# 
# This script loops trought all children folders
# and creates list git remote URL's.
# 

param([Parameter(Mandatory=$true)][string]$searchDir,
      [Parameter(Mandatory=$false)][string]$outputDir)

# test input
# $outputDir="C:\Users\miros\OneDrive\Automation\PS"
# $outputDir=""
# $searchDir="C:\Users\miros\OneDrive\Automation\PS"

if(!(Test-Path $searchDir)){
    return;
}

$searchDir = Get-Item -Path $searchDir -Verbose # change path to object

if($outputDir -eq ""){
    $outputDir = $searchDir
}
else{
    $outputDir = Get-Item -Path $outputDir -Verbose # change path to object
}

$logFile = $outputDir.FullName + "\_GitRemoteList" + $searchDir.Name + ".txt"

if(Test-Path $logFile){
    Remove-Item $logFile
}

Get-Date | Out-File $logFile

"Root dir: " + $searchDir.FullName | Out-File $logFile -Append

$folders = Get-ChildItem -Path $searchDir.FullName | Where-Object{ $_.PSIsContainer }

foreach($folder in $folders)
{
    Set-Location $folder.FullName

    git config --get remote.origin.url | Out-File $logFile -Append
}

Start-Process $logFile

Read-Host -Prompt "Done - Press Enter to exit"
