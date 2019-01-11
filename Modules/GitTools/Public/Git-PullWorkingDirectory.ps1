<# 
.Synopsis 
    Pull for each directory in your WorkingDirectory directory
.PARAMETER WorkingDirectory 
    Your working directory, pull will be executed on all child folders.
.PARAMETER Sleep 
    Use sleep if you wannt to add some dely before closing the powershell host. 
    Delay in seconds.
.EXAMPLE 
    Git-OpenOriginUrl 'C:\Code\Powershell'
#> 
function Git-PullWorkingDirectory {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkingDirectory,
        [int16]$Sleep = 0,
        [switch]$WhatIf
    )

    $logPath = Get-LogPaht "Git-PullWorkingDirectory";

    Write-log "Starting with root: $WorkingDirectory" -Path $logPath 

    $dir = Get-ChildItem $WorkingDirectory | Where-Object {$_.PSISContainer} | select-object FullName

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
        
        Set-Location $d.FullName;
        
        if ($WhatIf){
            
            Write-Host "WhatIf -> Calling git pull --all in $($d.FullName)"
            
        } else {
            Write-log "git pull --all -> $($d.FullName)" -Path $logPath 

            Start-Process -FilePath git -ArgumentList @('pull','--all') -NoNewWindow -Wait
        }
    }
    
    if($Sleep -gt 0){

        Write-Host "Script will end in $Sleep sec";

        Start-Sleep -s $Sleep
    }
}
