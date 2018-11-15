# Miroslav Mikus 2018/04/26
# 
# Clone git url form clipboard to repository directory
# 

function Git-CloneClip {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$RepositoryDirectory,
        [switch]$UseSleep = $false
    )

    $logPath = Get-LogPaht "Git-CloneClip";

    $clip = get-clipboard;
    
    Write-log "Clip: $clip" -Path $logPath 
    
    Set-Location $RepositoryDirectory;
    
    Write-log "Run: git clone $clip" -Path $logPath 
    
    git clone $clip

    if ($UseSleep){

        Write-Host "Done - Script will end in 4 sec";
        
        Start-Sleep -s 4
    }
}