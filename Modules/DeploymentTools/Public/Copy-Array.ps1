function Copy-Array {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string[]]$Sources,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Destination,
        [Parameter(Position = 2)]
        [switch]$UseIgnoreFile = $false,
        [Parameter(Position = 2)]
        [string[]]$IgnoreFilter = @(),
        [switch]$WhatIf
    )
    
    try {
        # check if path exist -> if not create one
        if (!(test-path $Destination)) {
            Write-Host "Creating destination folder: $Destination";
            
            New-Item -ItemType Directory -Path $Destination;
        }
    }
    catch {
        Read-Host "Error while creating directory: " + $Destination +" ; press enter to continue script"
    }

    try {
        switch ($PsCmdlet.ParameterSetName) {
            "UseIgnoreFile" {
                $Sources | ForEach-Object 
                {
                    Copy-Item -Path $_ -Destination $Destination -Exclude (Get-IgnoreFile $_) -Force 
                }
            }
            "IgnoreFilter" {
                $Sources | ForEach-Object 
                { 
                    Copy-Item -Path $_ -Destination $Destination -Exclude $IgnoreFilter -Force 
                }
            }
        }
    }
    catch {
        Write-Host "Error while copying files";
        Write-Host "Sources: " + $Sources;
        Write-Host "Destination: " + $Destination;
        Read-Host "Press enter to continue script";
    }
}

