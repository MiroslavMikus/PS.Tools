# Miroslav Mikus 2018/06/08
# 
# This script changes user name or user email for the current repository
# 

param([string]$root, [string]$userName, [string]$userEmail)

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

Write-log "Starting with root: $root" -Path $logPath 
    
if($root -eq ""){

    Write-log "Root cant be empty" -Path $logPath -Level Error 

    Read-Host -Prompt "Done - Press Enter to exit"
    
    return;
}

if(($userName -eq "") -and ($userEmail -eq "")){

    Write-log "userName or userEmail have to be set" -Path $logPath -Level Error 

    Read-Host -Prompt "Done - Press Enter to exit"

    return;
}

$oldName = git config user.name

if(!$userName -eq "" -and !$userName -eq $oldName){

    git config user.name $userName

    Write-log "User name changed from $oldName to $userName" -Path $logPath 
}

$oldEmail = git config user.email

if(!$userEmail -eq "" -and !$userEmail -eq $oldEmail){

    git config user.email $userName

    Write-log "User email changed from $oldName to $userEmail" -Path $logPath 
}

Read-Host -Prompt "Done - Press Enter to exit"
