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
		
		return ($ignoreContent | Select-Object { if ($_.StartsWith('*')) { return "{0}{1}" -f '\', $_ } else {return $_} })
    }
    else {
        Write-Host "Ignore file was not found: $ignoreFile"
        
        return @();
    }
}

Get-IgnoreFile C:\temp\ps1\

$Path = "C:\temp\ps1\"

$PSDefaultParameterValues['Select-Object:Verbose'] = $false
$VerbosePreference = "SilentlyContinue"