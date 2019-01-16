function Sort-Files([hashtable]$setupHashTable, [string]$rootFolder, [switch]$WhatIf, [switch]$Verbose)
{
    Write-Host "Start sorting files with root folder '$rootFolder'"

    # calculate progress
    $filterCount;
    $setupHashTable.Keys | ForEach-Object { $filterCount += $setupHashTable[$_].Length }

    $setupHashTable.Keys | ForEach-Object {
    
        if (!(Test-Path -Path $_) -and ($hashTable[$_].Count -gt 0)){
            Write-Host "Directory '$_' was created"
            New-Item -ItemType directory -Path $_ -WhatIf:$WhatIf -Verbose:$Verbose
        }
    
        $destinationFolder = $_;

        foreach ($filter in $hashTable[$_]) {

            # print out progress
            $current++;
            $currentProgress =  $current / ($filterCount / 100) ;
            Write-Progress -Activity "Processing $_ and filter: $filter" -Status "$currentProgress% Complete:" -PercentComplete $currentProgress

            $files = Get-ChildItem -Path $rootFolder -Filter $filter;

            $files | Copy-Item -Destination (Join-Path $destinationFolder $_.Name) -WhatIf:$WhatIf -Verbose:$Verbose
            
            $files | Remove-Item -WhatIf:$WhatIf -Confirm:$false -Verbose:$Verbose
        }
    }
}

function Get-DefaultSortTable {
    param (
        [string]
        $BasePath
    )

    $Programs = Join-Path $BasePath 'Programs'
    $Compressed = Join-Path $BasePath 'Compressed'
    $Documents = Join-Path $BasePath 'Documents'
    $Pictures = Join-Path $BasePath 'Pictures'
    $Video = Join-Path $BasePath 'Video'
    $Music = Join-Path $BasePath 'Music'
    
    return @{
        $Programs= @('*.exe','*.msi');
        $Compressed= @('*.zip', '*.rar', '*.7z');
        $Documents= @('*.doc', '*.docx', '*.xls', '*.xlsx', '*.pdf');
        $Pictures= @('*.jpg', '*.png');
        $Video= @('*.mp4', '*.3gp', '*.mkv');
        $Music= @('*.mp3')
    }    
}
Get-DefaultSortTable 'F:\Downloads';


clear
Sort-Files $hashTable $root

# $jsonTable = ConvertTo-Json $hashTable

# $hsthTable = ConvertFrom-Json $jsonTable