function Compress-ArchiveExtended {
    param (
        [string]$Path,
        [string]$DestinationPath
    )

    $ignoreText = Get-IgnoreFile $Path

    Get-ChildItem $Path -Exclude $ignoreText | Compress-Archive -DestinationPath $DestinationPath -CompressionLevel Fastest
}
