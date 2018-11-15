# Miroslav Mikus 2018/05/09
# 
# This script will take first link from 'git remote -v' 
# and open it in selected browser
# 
function Git-OpenOriginUrl {
    param (
            [Parameter(Mandatory=$true)]
            [string]$RepositoryDirectory,
            [Parameter(Mandatory=$false)]
            [string]$Browser,
            [Parameter(Mandatory=$false)]
            [switch]$UseSleep = $false,
            [switch]$WhatIf
    )
    $logPath = Get-LogPaht "Git-OpenOriginUrl";

    Set-Location $RepositoryDirectory

    $localRemote = (git remote -v)

    $link = SearchLink($localRemote[0]);

    if ($WhatIf){

        Write-log "WhatIf-> found link: '$link'" -Path $logPath 

        Write-log "WhatIf-> Browser: '$Browser'" -Path $logPath 

        return;
    }

    if ($Browser -eq ""){
        
        Write-log "Opening: $link" -Path $logPath 

        Start-Process $link 
    }
    else{

        Write-log "Opening with $Browser : $link" -Path $logPath 
        
        Start-Process -FilePath $Browser -ArgumentList $link
    }

    if($UseSleep){

        Write-Host "Script will end in 4 sec";

        Start-Sleep -s 4
    }
}

function SearchLink ([string]$data) {

    $startPosition = $data.IndexOf("http");
    
    $endPosition = $data.IndexOf("(");
    
    return $data.Substring($startPosition, $endPosition - $startPosition).Trim();
}