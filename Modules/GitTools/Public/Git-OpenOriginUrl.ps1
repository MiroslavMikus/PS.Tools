<# 
.Synopsis 
    This script will take first link from 'git remote -v' 
    and open it in selected browser 
.PARAMETER RepositoryDirectory 
    Git repository root folder.
.PARAMETER Sleep 
    Use sleep if you wannt to add some dely before closing the powershell host. 
    Delay in seconds.
.EXAMPLE 
    Git-OpenOriginUrl 'C:\Code\Powershell'
#> 
function Git-OpenOriginUrl {
    param (
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]  
            [string]$RepositoryDirectory,
            [string]$Browser,
            [int16]$Sleep = 0,
            [switch]$WhatIf
    )

    $logPath = Get-LogPaht "Git-OpenOriginUrl";

    Set-Location $RepositoryDirectory

    $link = git config --get remote.origin.url

    if ($WhatIf){

        Write-log "WhatIf-> found link: '$link'" -Path $logPath 

        Write-log "WhatIf-> Browser: '$Browser'" -Path $logPath 

        return;
    }

    if ($Browser -eq ""){
        
        Write-log "Opening: $link" -Path $logPath 

        Start-Process $link 
    }
    else{

        Write-log "Opening with $Browser : $link" -Path $logPath 
        
        Start-Process -FilePath $Browser -ArgumentList $link
    }

    if($Sleep -gt 0){

        Write-Host "Script will end in $Sleep sec";

        Start-Sleep -s $Sleep
    }
}