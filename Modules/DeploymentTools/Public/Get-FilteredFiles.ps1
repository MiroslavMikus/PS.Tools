function Get-FilteredFiles {
	param (
        [Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Path, 
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string[]]$IgnoreFilter,
		[switch]$InvertFilter = $false
	)
	$filesToProcess = @();

	if ($InvertFilter) {
		Write-Verbose "Reverting ignore file"
		
		$preProcessFilter = Format-Filter $IgnoreFilter

		Get-ChildItem $Path |
			Foreach-Object {
				foreach ($filter in $preProcessFilter) {
					Write-Debug "Comparing $_ with $filter, result = $($_ -match $filter)"
					if ($_ -match $filter) {
						$filesToProcess += $_
					}
				}
			}
	}
	else {
		$filesToProcess = Get-ChildItem $Path -Exclude $IgnoreFilter
	}
	return $filesToProcess
}