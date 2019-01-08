function Sort-Files([hashtable]$setupHashTable, [string]$rootFolder, [switch]$WhatIf)
{
    Write-Host "Starting with folder '$rootFolder'"

    $setupHashTable.Keys | ForEach-Object {
        Write-Host "Processing $_"
    
        if (!(Test-Path -Path $_)){
			Write-Host "Directory '$_' was created"
			if(!$WhatIf){
				mkdir $_
			}
        }
    
        $destinationFolder = $_;

        foreach ($filter in $hashTable[$_]) {
    
            Get-ChildItem -Path $rootFolder -Filter $filter | ForEach-Object {
                
				$destination = (Join-Path $destinationFolder $_.Name);
				
				Write-Host "Copying $($_.FullName) to $destination"
				
				If(!$WhatIf){
					Copy-Item -Path $_.FullName -Destination $destination
				}
                
            }
        }
    }
}

$root = 'C:\Users\mmikus\Downloads';

$Programs = Join-Path $root 'Programs'
$Compressed = Join-Path $root 'Compresed'
$Documents = Join-Path $root 'Documents'
$Media = Join-Path $root 'Media'
$Pictures = Join-Path $Media 'Pictures'
$Video = Join-Path $Media 'Video'
$Music = Join-Path $Media 'Music'

$hashTable = @{
    $Programs= @('*.exe','*.msi');
    $Compressed= @('*.zip', '*.rar', '*.7z');
    $Documents= @('*.doc', '*.docx', '*.xls', '*.xlsx', '*.pdf');
    $Pictures= @('*.jpg', '*.png');
    $Video= @('*.mp4', '*.3gp', '*.mkv');
    $Music= @('*.mp3')
}

Sort-Files $hashTable $root


# $jsonTable = ConvertTo-Json $hashTable

# $hsthTable = ConvertFrom-Json $jsonTable