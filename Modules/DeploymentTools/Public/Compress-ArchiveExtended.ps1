function Compress-ArchiveExtended {
    param (
        [string]$Path,
		[string]$DestinationPath,
		[switch]$InvertFileIgnore
    )

	$ignoreText = Get-IgnoreFile $Path
	
	Write-Host "Ignore content: " + $ignoreText
	
	if ($InvertFileIgnore) {

		Write-Host "Reverting ignore file"

		Get-ChildItem $Path |
			Where-Object {
				foreach ($filter in $ignoreText) {
					if ($_ -match $filter) {
						return $true;
					}
				}
				return $false;
			} |
				Compress-Archive -DestinationPath $DestinationPath -CompressionLevel Fastest
	}
	else {
		Get-ChildItem $Path -Exclude $ignoreText | Compress-Archive -DestinationPath $DestinationPath -CompressionLevel Fastest
	}
}

Compress-ArchiveExtended -Path C:\temp\ps1 -DestinationPath C:\temp\ps2\target.zip -InvertFileIgnore
