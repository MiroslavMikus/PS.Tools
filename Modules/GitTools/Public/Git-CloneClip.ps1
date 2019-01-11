<# 
.Synopsis 
    Clone git url form clipboard to repository directory
.Description
    Just copy the git URL to your clipboard and execute this command.
    I embed this script to my total commander so I can directly clone to the selected directory.
.PARAMETER WorkingDirectory 
    Your working directory.
.PARAMETER Sleep 
   Use sleep if you wannt to add some dely before closing the powershell host. 
   Delay in seconds.
.EXAMPLE 
    Copy https://github.com/MiroslavMikus/Course.LibraryManagement.git
    Git-CloneClip -WorkingDirectory 'C:\Code'
#> 
function Git-CloneClip {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$WorkingDirectory,
        [int16]$Sleep = 0
    )

    $logPath = Get-LogPaht "Git-CloneClip";

    $clip = get-clipboard;
    
    Write-log "Clip: $clip" -Path $logPath 
    
    Set-Location $WorkingDirectory;
    
    Write-log "Run: git clone $clip" -Path $logPath 
    
    git clone $clip

    if ($Sleep -gt 0){

        Write-Host "Done - Script will end in $Sleep sec";
        
        Start-Sleep -s $Sleep 
    }
}