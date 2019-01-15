function Get-IgnoreFile {
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
        $Path
    )
    
    $ignoreFile = Join-Path $Path ".fileignore";
    
    if (Test-Path $ignoreFile) {
		
		Write-Host "Ignore file was found: $ignoreFile"
		
		$ignoreContent = Get-Content $ignoreFile

        foreach ($filter in $ignoreContent) {
            if ($filter.StartsWith('*')) {
                        "{0}{1}" -f '\', $filter 
                    }
                    else {
                        $filter
                    }
        }
    }
    else {
        Write-Host "Ignore file was not found: $ignoreFile"
        
        return @();
    }
}