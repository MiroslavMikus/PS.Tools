function Sort-Files([hashtable]$setupHashTable, [string]$rootFolder)
{
    Write-Host "Starting with folder '$rootFolder'"

    $setupHashTable.Keys | ForEach-Object {
        Write-Host "Processing $_"
    
        if (!(Test-Path -Path $_)){
            mkdir $_
            Write-Host "Directory '$_' was created"
        }
    
        $destinationFolder = $_;

        foreach ($filter in $hashTable[$_]) {
    
            $children =  Get-ChildItem -Path $rootFolder -Filter $filter;
        
            $count =  $children | Measure-Object | Select-Object Count

            Write-Host "Measure $filter = $count"
           
            $children | ForEach-Object {
                
                Copy-Item -Path $_.FullName -Destination (Join-Path $destinationFolder $_.Name)
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
    $Programs=@('*.exe');
    $Compressed= @('*.zip', '*.rar', '*.7z');
    $Documents= @('*.doc', '*.docx', '*.xls', '*.xlsx', '*.pdf');
    $Pictures= @('*.jpg', '*.png');
    $Video= @('*.mp4', '*.3gp', '*.mkv');
    $Music= @('*.mp3')
}

Sort-Files $hashTable $root