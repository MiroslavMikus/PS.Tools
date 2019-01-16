function Git-Bundle {
    param (
        [string]$RepoPath,
        [string]$TargetPath,
        [string]$Branch = "master"
    )
    
    $fileName = Join-Path $TargetPath "$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)_$Branch.bundle"

    Set-Location $RepoPath

    git bundle create $fileName $Branch
}