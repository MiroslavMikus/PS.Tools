# Miroslav Mikus 2018/04/26
# 
# Pull for each directory in your WorkingDirectory directory
# 

function Git-PullWorkingDirectory {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkingDirectory,
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

            Start-Process -FilePath git -ArgumentList @('pull','--all') -NoNewWindow
        }
    }
    
    Write-log "Done" -Path $logPath 
    
    Read-Host -Prompt "Done - Press Enter to exit"
}
