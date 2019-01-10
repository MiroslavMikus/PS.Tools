function Sort-Files([hashtable]$setupHashTable, [string]$rootFolder, [switch]$WhatIf, [switch]$Verbose)
{
    Write-Host "Starting with folder '$rootFolder'"

    $setupHashTable.Keys | ForEach-Object {
    
        if (!(Test-Path -Path $_) -and ($hashTable[$_].Count -gt 0)){
            Write-Host "Directory '$_' was created"
            New-Item -ItemType directory -Path $_ -WhatIf:$WhatIf -Verbose:$Verbose
        }
    
        $destinationFolder = $_;

        foreach ($filter in $hashTable[$_]) {

            Write-Host "Processing $_ and filter: $filter"
            
            $files = Get-ChildItem -Path $rootFolder -Filter $filter;

            $files | Copy-Item -Destination (Join-Path $destinationFolder $_.Name) -WhatIf:$WhatIf -Verbose:$Verbose
            
            $files | Remove-Item -WhatIf:$WhatIf -Confirm:$false -Verbose:$Verbose
        }
    }
}

$root = 'F:\Downloads';

$Programs = Join-Path $root 'Programs'
$Compressed = Join-Path $root 'Compressed'
$Documents = Join-Path $root 'Documents'
$Pictures = Join-Path $root 'Pictures'
$Video = Join-Path $root 'Video'
$Music = Join-Path $root 'Music'

$hashTable = @{
    $Programs= @('*.exe','*.msi');
    $Compressed= @('*.zip', '*.rar', '*.7z');
    $Documents= @('*.doc', '*.docx', '*.xls', '*.xlsx', '*.pdf');
    $Pictures= @('*.jpg', '*.png');
    $Video= @('*.mp4', '*.3gp', '*.mkv');
    $Music= @('*.mp3')
}

clear
Sort-Files $hashTable $root -Verbose


# $jsonTable = ConvertTo-Json $hashTable

# $hsthTable = ConvertFrom-Json $jsonTable