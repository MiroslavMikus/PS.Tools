<# 
.Synopsis 
    This script changes user name or user email for the current or global repository
.PARAMETER RepositoryDirectory 
   Git repository root folder.
.PARAMETER UserName 
   Desired user name.
.PARAMETER UserEmail 
   Desired user email.
.PARAMETER Global 
   Switch between local and global config
.PARAMETER Sleep 
   Use sleep if you wannt to add some dely before closing the powershell host. 
   Delay in seconds.
.EXAMPLE 
    Git-ChangeUser -UserName "Miroslav Mikus" -UserEmail "Miroslav.Mikus@outlook.com"
#> 
function Git-ChangeUser {
    param (
        [string]$RepositoryDirectory, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$UserName, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$UserEmail,
        [switch]$Global,
        [int16]$Sleep = 0
    )

    $logPath = Get-LogPaht "Git-ChangeUser";

    if ($Global){

        Write-log "Updating global settings" -Path $logPath 

        $globalSwitch = "--global";
    } else {

        Write-log "Updating local settings" -Path $logPath 

        $globalSwitch = "";
    }

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
    
    if ($Sleep -gt 0){

        Write-Host "Done - Script will end in $Sleep sec";
        
        Start-Sleep -s $Sleep 
    }
}