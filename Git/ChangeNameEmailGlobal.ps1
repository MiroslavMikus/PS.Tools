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

Write-log "Starting with repositor folder: $root" -Path $logPath 
    
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

$oldName = git config --global user.name

if(!$userName -eq ""){

    if($userName -eq $oldName){

        Write-log "User name is the same. Name will be not changed. The current value is $oldName" -Path $logPath -Level Error

    }else{

        git config --global user.name $userName 

        Write-log "User name changed from $oldName to $userName" -Path $logPath 
    }
}

$oldEmail = git config --global user.email 

if(!$userEmail -eq ""){

    if($userEmail -eq $oldEmail){

        Write-log "User email is the same. Email will be not changed. The current value is $oldEmail" -Path $logPath -Level Error

    } else {

        git config --global user.email $userEmail
    
        Write-log "User email changed from $oldEmail to $userEmail" -Path $logPath 
    }

}

Read-Host -Prompt "Done - Press Enter to exit"
