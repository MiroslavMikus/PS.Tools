# Miroslav Mikus 2018/03/04
# 
# Executes Git status Commit & Push
# Enter empty message to stop the script
# 

# Requires -Modules SimpleLogger
function Git-CommitPush {

    param(
        [string]$CommitMessage,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$RootFolder
        )

    $logPath = Get-LogPaht "Git-AutoPush";
    
    Write-log "Starting with repositor folder: $RootFolder" -Path $logPath;
    
    Set-Location $RootFolder;
    
    Write-log "Email $(git config user.email)" -Path $logPath;
    Write-log "Status $(git status)" -Path $logPath;
    
    Write-Host "######";
    Write-Host "Git add -A; commit; push is following";
    Write-Host "######";
    
    # let the user enter the commit message
    if ($CommitMessage -eq "") {

        $CommitMessage = Read-Host -Prompt "Enter Commit message";
        
        # break execution if is the message empty
        if ($CommitMessage -eq "") {
            return;
        }
    }
    
    git add -A
    
    git commit -m "$CommitMessage"
    
    git push
}