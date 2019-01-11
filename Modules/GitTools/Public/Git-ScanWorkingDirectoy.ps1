<# 
.Synopsis 
    This script loops trought all sub-folders
    and creates list git remote URL's.
.PARAMETER WorkingDirectory 
    Your working directory.
.EXAMPLE 
    Git-OpenOriginUrl 'C:\Code\Powershell'
#> 
function Git-ScanWorkingDirectoy {
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDirectory
    )

    $logPath = Get-LogPaht "Git-ScanWorkingDirectoy";

    if(!(Test-Path $WorkingDirectory)){
    
        Write-log "Search directory doesnt exist: $WorkingDirectory" -Path $logPath -Level Error
    }

    Write-log "Search directory: $WorkingDirectory" -Path $logPath

    $WorkingDirectoryObject = Get-Item -Path $WorkingDirectory -Verbose # change path to object

    $folders = Get-ChildItem -Path $WorkingDirectoryObject.FullName | Where-Object{ $_.PSIsContainer }

    $urls = @();

    foreach($folder in $folders)
    {
        Set-Location $folder.FullName
    
        $urls += (git config --get remote.origin.url);
    }

    return $urls
}
