$dirs = @("C:\S\.Base\", "C:\S\.Benteler", "C:\S\.Brussels", "C:\S\.Gyoer", "C:\S\.Porsche", "C:\S\.SHW")

$dirs = @("C:\s\.AllRepos\")

$dir = @();

foreach($tempDir in $dirs)
{
    $dir += dir $tempDir | ?{$_.PSISContainer}
}


$gitHist = @();

foreach ($d in $dir){
    Set-Location $d.FullName
    Write-Host $d.FullName
    $gitHist += (git log --format="%ai`t%H`t%an`t%ae`t%s") | ConvertFrom-Csv -Delimiter "`t" -Header ("Date","CommitId","Author","Email","Subject")    
}

$gitHist | Group-Object Author | Sort-Object Count -Descending

##------------------------------------------------
$dirs = @("C:\s\.AllRepos\")

$dir = @();

foreach($tempDir in $dirs)
{
    $dir += dir $tempDir | ?{$_.PSISContainer}
}

$gitHist = @();

foreach ($d in $dir| Select-Object -Skip 30 -First 30){
    Set-Location $d.FullName
    Write-Host $d.FullName
    $gitHist += (git shortlog -s ) | ConvertFrom-Csv -Delimiter "`t" -Header ("Count","Author")    
}

$historyResult = $gitHist | Group-Object Author | Sort-Object Count -Descending

$myResult = @{};

foreach($group in $historyResult){

    $myResult[$group.Name] = $group.Group | ForEach-Object {$result =0 } {$result += $_.Count} {$result}
}

$myResult | Sort-Object Value -Descending