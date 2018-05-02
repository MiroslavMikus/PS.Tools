# Miroslav Mikus 2018/04/09
# 
# This script will sync your fork with the remote repository.
# You can run this after succesful pull request.
# 

param([Parameter(Mandatory=$true)][string]$upstreamUrl,
      [Parameter(Mandatory=$false)][string]$localRepositoryDir,
      [Parameter(Mandatory=$false)][string]$upstreamName)

# Testdata
#$upstreamUrl = "https://github.com/etrupja/MathHelper.io.git"

if ($localRepositoryDi -eq "") {
    $localRepositoryDir = $MyInvocation.MyCommand.Path;
}

if ($upstreamName -eq "") {
    $upstreamName = "upstream"
}

# change directory
Set-Location $localRepositoryDi

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
