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
    
    Write-log "Name: $(git config user.name); Email: $(git config user.email)" -Path $logPath;
    
    git add -A
    
    git commit -m "$CommitMessage"
    
    git push
}