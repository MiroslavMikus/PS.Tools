function Git-GetStatus {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$RepositoryDirectory
    )
    Set-Location $RepositoryDirectory;

    $logPath = Get-LogPaht "Git-GetStatus";

    Write-log "User email: $(git config user.email)" -Path $logPath;
    Write-log "User name $(git config user.Name)" -Path $logPath;
    Write-log "Git status: $(git status)" -Path $logPath;
}