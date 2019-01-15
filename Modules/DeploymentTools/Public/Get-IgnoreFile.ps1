function Get-IgnoreFile {
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
        $Path
    )
    
    $ignoreFile = Join-Path $Path ".fileignore";
    
    if (Test-Path $ignoreFile) {
		
		Write-Verbose "Ignore file was found: $ignoreFile"
		
        return Get-Content $ignoreFile
    }
    else {
        Write-Verbose "Ignore file was not found: $ignoreFile"
        
        return @();
    }
}