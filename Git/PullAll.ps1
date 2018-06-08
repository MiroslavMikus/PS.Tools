# Miroslav Mikus 2018/04/26
# 
# Pull for each directory in $root directory
# 

param([string]$root)

#test
#$root = "C:\S";

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

Write-log "Starting with root: $root" -Path $logPath 
    
if ($root -eq "") 
{
    Write-log "Root cannot be empty!" -Path $logPath -Level Error

    Read-Host -Prompt "Script will exit"
    
    return;
}

$dir = Get-ChildItem $root | Where-Object {$_.PSISContainer} | select-object FullName

$count = $dir.Count;
$current = 0;

# make space for progressbar
for ($i = 0; $i -lt 5; $i++) {
    Write-Host $([Environment]::Newline);
}

foreach ($d in $dir) 
{
    $current++;

    [int]$currentProgress = $current / ($count / 100) ;

    Write-Progress -Activity "Pull in all folders" -Status "$currentProgress% Complete:" -PercentComplete $currentProgress;

    Write-log "git pull --all -> $($d.FullName)" -Path $logPath 

    Set-Location $d.FullName;

    git pull --all
}

Write-log "Done" -Path $logPath 

Read-Host -Prompt "Done - Press Enter to exit"