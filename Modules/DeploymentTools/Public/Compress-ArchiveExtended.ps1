Remove-Item $ZipFileResult
Compress-ArchiveExtended -Path $YourDirToCompress -DestinationPath $ZipFileResult

function Compress-ArchiveExtended {
    param (
        $Path,
        $DestinationPath
    )

    $ignorePath = Join-Path $Path ".zipignore";

    if(Test-Path $ignorePath){

        Write-Host "Ignore file was found"

        $ignoreText = Get-Content $ignorePath;

        Write-Host $ignoreText

    } else {
        $ignoreText = @();
    }

    Get-ChildItem $Path -Exclude $ignoreText | Compress-Archive -DestinationPath $DestinationPath -CompressionLevel Fastest
}
