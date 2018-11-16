function Get-IgnoreFile {
    param (
        $Path
    )
    
    $ignoreFile = Join-Path $Path ".fileignore";
    
    if(Test-Path $ignoreFile){

        Write-Host "Ignore file was found"

        $ignoreText = Get-Content $ignoreFile;

        return $ignoreText

    } else {
        Write-Host "Ignore file was not found"
        
        return @();
    }
}