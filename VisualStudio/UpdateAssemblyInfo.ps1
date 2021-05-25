param($rootFolder)

Set-Location $rootFolder

$branch= &git rev-parse --abbrev-ref HEAD 
$gitHist = (git log --format="%ai`t%H`t%an`t%ae`t%s" -n 1) | ConvertFrom-Csv -Delimiter "`t" -Header ("Date","CommitId","Author","Email","Subject")
$commit = $gitHist.CommitId.SubString(0,7);
$tag = "{0}_{1}" -f $branch, $commit


$assemblyVersionPattern = '\[assembly: AssemblyVersion\("(.*)"\)\]'
$assemblyInformationPattern = '\[assembly: AssemblyInformationalVersion\("(.*)"\)\]'
$assemblyFileInformationPattern = '\[assembly: AssemblyFileVersion\("(.*)"\)\]'

$AssemblyFiles = Get-ChildItem . AssemblyInfo.cs -rec

$year = Get-Date -Format "yyyy"
$month = Get-Date -Format "MM"
$day = Get-Date -Format "dd"
$time = Get-Date -Format "HHmm"

Write-Host Found $AssemblyFiles.Count files

$newVersion = "{0}.{1}.{2}.{3}" -f $year, $month, $day, $time 
$assemblyFileVersion = '[assembly: AssemblyFileVersion("{0}")]' -f $newVersion
$assemblyVersion  = '[assembly: AssemblyVersion("{0}")]' -f $newVersion
$assemblyInformation = '[assembly: AssemblyInformationalVersion("{0}")]' -f $tag

foreach ($file in $AssemblyFiles)
{
    write-host Updating $file.PSPath
    # search for assembly version
    (Get-Content $file.PSPath) | ForEach-Object  { 
        # % {$_ -replace $assemblyVersionPattern, $assemblyVersion } |
        % {$_ -replace $assemblyInformationPattern, $assemblyInformation  } |
        % {$_ -replace $assemblyFileInformationPattern, $assemblyFileVersion  }
    } | Set-Content $file.PSPath

    $containsWord = (Get-Content $file.PSPath) | %{$_ -match $assemblyInformationPattern}

    if (-not( $containsWord -contains $true))
    {
        Add-Content $file.PSPath ('[assembly: AssemblyInformationalVersion("{0}")]' -f $tag)
    }
}
Read-Host Done - press any key to close
