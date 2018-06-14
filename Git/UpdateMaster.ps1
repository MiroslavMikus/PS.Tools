# Miroslav Mikus 2018/06/14
# 
# This script will switch to master branch, execute git pull and switch back to the previous branch
# 

param([Parameter(Mandatory=$true)][string]$root)

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

Set-Location $root

Write-log "Root: $root" -Path $logPath

Set-Variable master -Option Constant -Value "master"

$currentBranch = (git branch | Where-Object {$_[0] -eq "*"}).Split(" ")[1]

Write-log "The current branch is: $currentBranch" -Path $logPath

if ($currentBranch -eq $master){
    # just update
    git pull

}else{
    # switch to master, update, switch back to the current branch

    git checkout $master

    git pull

    git checkout $currentBranch
}

Write-log "Done" -Path $logPath

Read-Host -Prompt "Press Enter to exit"
