function Copy-Array {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Sources,
        [Parameter(Mandatory = $true)]
        [string]$Destination,
        [Parameter(Position = 2)]
        [switch]$UseIgnoreFile = $false,
        [Parameter(Position = 2)]
        [string[]]$IgnoreFilter = @()
    )
    
    try {
        # check if path exist -> if not create one
        if (!(test-path $Destination)) {

            Write-Log "Creating destination folder: $Destination";
            
            New-Item -ItemType Directory -Path $Destination;
        }
    }
    catch {
        Read-Host "Error while creating directory: " + $Destination +" ; press enter to continue script"
    }

    if ($UseIgnoreFile) {

        $Sources | ForEach-Object `
        {
            # load new ignore file for each element in source array
            Copy-Item -Path $_ -Destination $Destination -Exclude (Get-IgnoreFile $_) -Force 
        }
    }
    else {

        $Sources | ForEach-Object `
        {
            Copy-Item -Path $_ -Destination $Destination -Exclude $IgnoreFilter -Force 
        }
    }
}

