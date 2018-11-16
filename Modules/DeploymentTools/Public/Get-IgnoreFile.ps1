function Get-IgnoreFile {
    param (
        $Path
    )
    
    $ignoreFile = Join-Path ([io.Path]::GetDirectoryName($Path)) ".fileignore";
    
    if (Test-Path $ignoreFile) {

        Write-Host "Ignore file was found: $ignoreFile"

        $ignoreText = Get-Content $ignoreFile;

        return $ignoreText

    }
    else {
        Write-Host "Ignore file was not found: $ignoreFile"
        
        return @();
    }
}