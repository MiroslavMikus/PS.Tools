function Compress-ArchiveExtended {
	[cmdletbinding(
        DefaultParameterSetName='UseDefaultFilter'
    )]
    param (
        [string]$Path,
		[string]$DestinationPath,
		[switch]$InvertFileIgnore,
		[Parameter(ParameterSetName="InjectIgnoreFilter")]
		[string[]]$IgnoreFilter,
		[Parameter(ParameterSetName="UseDefaultFilter")]
		[switch]$UseDefaultIgnoreFile = $true
	)

	if ($UseDefaultIgnoreFile){
		$IgnoreFilter = Get-IgnoreFile -Path $Path

		Write-Verbose "Ignore content: $IgnoreFilter"

		if ($IgnoreFilter.Length -eq 0) {
			# user want to use default ignore file, but there is none
			return;
		}
	}

	$filesToProcess = @();

	if ($IgnoreFilter.Length -gt 0){
		$filesToProcess = Get-FilteredFiles -Path $Path -IgnoreFilter $IgnoreFilter -InvertFilter:$InvertFileIgnore
	}
	else{
		$filesToProcess = Get-ChildItem $Path
	}	

	Write-Verbose ("Processing files count: " + $filesToProcess.Length)

	if ($filesToProcess.Length -gt 0){
		$filesToProcess | Compress-Archive -DestinationPath $DestinationPath -CompressionLevel Fastest
	}
	else{
		Write-Verbose "Nothing to compress!"
	}
}

Compress-ArchiveExtended -Path C:\temp\ps1 -DestinationPath C:\temp\ps2\include.zip -InvertFileIgnore
Compress-ArchiveExtended -Path C:\temp\ps1 -DestinationPath C:\temp\ps2\exclude.zip -IgnoreFilter (Get-IgnoreFile C:\temp\ps1)
Compress-ArchiveExtended -Path C:\temp\ps1 -DestinationPath C:\temp\ps2\excludeö.zip 


Get-FilteredFiles -Path C:\temp\ps1 -IgnoreFilter (Get-IgnoreFile C:\temp\ps1)
Get-FilteredFiles -Path C:\temp\ps1 -IgnoreFilter (Get-IgnoreFile C:\temp\ps1) -InvertFilter