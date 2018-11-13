# Miroslav Mikus 2018/03/04
# 
# Executes Git status Commit & Push
# Enter empty message to stop the script
# 

# Requires -Modules SimpleLogger
function Git-AutoPush {

    param(
        [string]$commitMessage,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$rootFolder
        )

    $logPath = Get-LogPaht "Git-AutoPush";
    
    Write-log "Starting with repositor folder: $rootFolder" -Path $logPath 
    
    Set-Location $rootFolder
    
    Write-log "Email $(git config user.email)" -Path $logPath 
    Write-log "Status $(git status)" -Path $logPath 
    
    Write-Host "######"
    Write-Host "Git add -A; commit; push is following"
    Write-Host "######"
    
    # let the user enter the commit message
    if ($commitMessage -eq "") {

        $commitMessage = Read-Host -Prompt "Enter Commit message:"
        
        # break execution if is the message empty
        if ($commitMessage -eq "") {
            return;
        }
    }
    
    git add -A
    
    git commit -m "$commitMessage"
    
    git push
}