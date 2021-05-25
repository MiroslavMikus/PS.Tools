<# 
.Synopsis 
   Ensure-PathAccess iterates over all files in all directories from path.
   Returns array of founded paths.
.PARAMETER FileFilter 
   File name RegEx. Example 'Nuget.exe', 'notepad.*', '/*.exe', 
.EXAMPLE 
   Ensure-PathAccess 'notepad.exe'  
.EXAMPLE 
   Ensure-PathAccess 'notepad*'  
.EXAMPLE 
    Ensure-PathAccess '(N|n)otepad.exe'
.EXAMPLE 
    Ensure-PathAccess '(M|m)s(B|b)uild*'

#> 
function Ensure-PathAccess {
    param (
        [Parameter(Mandatory=$true)] 
        [ValidateNotNullOrEmpty()] 
        [regex]$FileFilter,
        [switch]$SearchInFullName
    )

    $path = $env:Path.Split(';'); 

    $result = @();

    foreach ($directory in $path) {

        if ( -Not (Test-Path -Path $directory ) )
        {
            Write-Host "Path directory [$directory] does not exist!"
            continue;
        }
         
        $children = Get-ChildItem -Path $directory

        foreach ($child in $children) {
            if ($SearchInFullName){
                if($child.FullName -match $FileFilter){
                    $result += $child.FullName;
                }
            }
            else{
                if($child.Name -match $FileFilter){
                    $result += $child.FullName;
                }
            }
        }
    }
    return $result | Select-Object -uniq
}

#$result = Ensure-PathAccess "nuget*"