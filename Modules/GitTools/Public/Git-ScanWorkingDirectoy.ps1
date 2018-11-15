# Miroslav Mikus 2018/03/04
# 
# This script loops trought all children folders
# and creates list git remote URL's.
# 

function Git-ScanWorkingDirectoy {
    param (
        [Parameter(Mandatory=$true)]
        [string]$searchDir
    )

    $logPath = Get-LogPaht "Git-ScanWorkingDirectoy";

    if(!(Test-Path $searchDir)){
    
        Write-log "Search directory doesnt exist: $searchDir" -Path $logPath -Level Error
    }

    Write-log "Search directory: $searchDir" -Path $logPath

    $searchDirObject = Get-Item -Path $searchDir -Verbose # change path to object

    $folders = Get-ChildItem -Path $searchDirObject.FullName | Where-Object{ $_.PSIsContainer }

    $urls = @();

    foreach($folder in $folders)
    {
        Set-Location $folder.FullName
    
        $urls += (git config --get remote.origin.url);
    }

    return $urls
}

function Git-ScanWorkingDirectoryToFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$OutputDirectory,
        [bool]$addHeader = $true
        
    )
    # todo continue here
}
