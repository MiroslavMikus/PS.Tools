# Miroslav Mikus 2018/04/09
# 
# This script will sync your fork with the remote repository.
# You can run this after succesful pull request.
# 

param([Parameter(Mandatory=$true)][string]$upstreamUrl,
      [Parameter(Mandatory=$false)][string]$localRepositoryDir,
      [Parameter(Mandatory=$false)][string]$upstreamName)


#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

if($upstreamUrl -eq ""){
    
    Write-log "UpstreamUrl parameter is missing" -Path $logPath -Level Error
    
    Read-Host -Prompt "Press Enter to exit"
    
    return;
}

Write-log "Upstream url: $upstreamUrl" -Path $logPath

# Testdata
#$upstreamUrl = "https://github.com/etrupja/MathHelper.io.git"

if ($localRepositoryDir -eq "") {
    $localRepositoryDir = $MyInvocation.MyCommand.Path;
}
Write-log "localRepositoryDir: $localRepositoryDir" -Path $logPath

if ($upstreamName -eq "") {
    $upstreamName = "upstream"
}
Write-log "Upstream url: $upstreamName" -Path $logPath

# change directory
Set-Location $localRepositoryDir

# check if remote contains 'upstreamName' and 'upsteramUrl'
$localRemote = (git remote -v)

if(!$localRemote -match "$upstreamName *$upstreamUrl"){

    if($localRemote -match "$upstreamName"){

        # remove remote -> remote contains wrong url
        git remote rm $upstreamName
    }

    ## set upstream
    git remote add $upstreamName $upstreamUrl
}

# download remote branch
git fetch $upstreamName

# merge curren branch with upstream
git merge origin/$upstreamName

# push changes to your fork
git push

Write-log "Done" -Path $logPath

Read-Host -Prompt "Done - Press Enter to exit"