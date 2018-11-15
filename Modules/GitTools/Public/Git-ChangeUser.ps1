# Miroslav Mikus 2018/06/08
# 
# This script changes user name or user email for the current repository or global
# 

function Git-ChangeUser {
    param (
        [string]$RepositoryDirectory, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$UserName, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$UserEmail,
        [switch]$Global
    )

    if ($Global){

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
    
    if($UserName -eq $oldName) {

        Write-log "User name is the same. Name will be not changed. The current value is $oldName" -Path $logPath -Level Error

    } else {

        git config $globalSwitch user.name $UserName 

        Write-log "User name changed from $oldName to $UserName" -Path $logPath 
    }

    $oldEmail = git config $globalSwitch user.email 

    if($UserEmail -eq $oldEmail) {
    
        Write-log "User email is the same. Email will be not changed. The current value is $oldEmail" -Path $logPath -Level Error
    
    } else {
    
        git config $globalSwitch user.email $UserEmail
    
        Write-log "User email changed from $oldEmail to $UserEmail" -Path $logPath 
    }

    Read-Host -Prompt "Done - Press Enter to exit"
}