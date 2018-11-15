# Miroslav Mikus 2018/06/08
# 
# This script changes user name or user email for the current repository or global
# 

function Git-ChangeUser {
    param (
        [string]$RepositoryDirectory, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$userName, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$userEmail,
        [switch]$global
    )

    if ($global){

        Write-log "Updating global settings" -Path $logPath 

        $globalSwitch = "--global";
    } else {

        Write-log "Updating global settings" -Path $logPath 

        $globalSwitch = "";
    }

    $logPath = Get-LogPaht "Git-AutoPush";

    if($RepositoryDirectory -eq ""){
    
        Write-log "Repository directory is  empty" -Path $logPath -Level Warning 
    
        $RepositoryDirectory = (Get-Item -Path ".\").FullName;

        Write-log "Current repository will be used: $RepositoryDirectory"
    }

    Write-log "Starting with repositor folder: $RepositoryDirectory" -Path $logPath 
    
    $oldName = git config $globalSwitch user.name
    
    if($userName -eq $oldName) {

        Write-log "User name is the same. Name will be not changed. The current value is $oldName" -Path $logPath -Level Error

    } else {

        git config $globalSwitch user.name $userName 

        Write-log "User name changed from $oldName to $userName" -Path $logPath 
    }

    $oldEmail = git config $globalSwitch user.email 

    if($userEmail -eq $oldEmail) {
    
        Write-log "User email is the same. Email will be not changed. The current value is $oldEmail" -Path $logPath -Level Error
    
    } else {
    
        git config $globalSwitch user.email $userEmail
    
        Write-log "User email changed from $oldEmail to $userEmail" -Path $logPath 
    }

    Read-Host -Prompt "Done - Press Enter to exit"
}