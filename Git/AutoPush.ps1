# Miroslav Mikus 2018/03/04
# 
# Executes Git status Commit & Push
# Enter empty message to stop the script
# 

param([string]$root)

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

if($root -eq ""){
    
    Write-log "Root parameter is missing" -Path $logPath -Level Error
    
    Read-Host -Prompt "Press Enter to exit"
    
    return;
}

Write-log "Starting with repositor folder: $root" -Path $logPath 

Set-Location $root

Write-log "Email $(git config user.email)" -Path $logPath 
Write-log "Status $(git status)" -Path $logPath 

Write-Host "######"
Write-Host "Git add -A; commit; push is following"
Write-Host "######"

$name = Read-Host -Prompt "Enter Commit message:"

if ($name -eq "") {
    return;
}

git add -A

git commit -m "$name"

git push

Read-Host -Prompt "Done - Press Enter to exit"