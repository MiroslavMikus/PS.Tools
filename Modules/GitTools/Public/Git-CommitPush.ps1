<# 
.Synopsis 
    Executes Git Status, Commit & Push
.PARAMETER CommitMessage
    Your commit message.
.PARAMETER RepositoryDirectory 
    Git repository root folder.
.EXAMPLE 
    Git-CommitPush -CommitMessage 'Init commit' -RepositoryDirectory 'C:\Code\Repository'
#> 
function Git-CommitPush {

    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$CommitMessage,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$RepositoryDirectory
        )

    $logPath = Get-LogPaht "Git-CommitPush";
    
    Write-log "Starting with repositor folder: $RepositoryDirectory" -Path $logPath;
    
    Set-Location $RepositoryDirectory;
    
    Write-log "Email $(git config user.email)" -Path $logPath;
    Write-log "Status $(git status)" -Path $logPath;
    
    Write-Host "######";
    Write-Host "Git add -A; commit; push is following";
    Write-Host "######";
    
    git add -A
    
    git commit -m "$CommitMessage"
    
    git push
}