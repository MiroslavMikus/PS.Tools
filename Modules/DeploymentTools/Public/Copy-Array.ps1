function Copy-Array {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]
        $Sources,
        [Parameter(Mandatory=$true)]
        [string]
        $Destination
    )
    
    try {
        # check if path exist -> if not create one
        if (!(test-path $Destination))
        {
            Write-Host "Creating destination folder: $Destination";
            
            New-Item -ItemType Directory -Path $Destination;
        }
    }
    catch {
        Read-Host "Error while creating directory: " + $Destination +" ; press enter to continue script"
    }

    try {
        $Sources | ForEach-Object { Copy-Item -Path $_ -Destination $Destination -Force }
    }
    catch {
        Write-Host "Error while copying files";
        Write-Host "Sources: " + $Sources;
        Write-Host "Destination: " + $Destination;
        Read-Host "Press enter to continue script";
    }
}

# Get-Process | Sort-Object CPU -Descending | Select-Object -Last 10 | Out-GridView
