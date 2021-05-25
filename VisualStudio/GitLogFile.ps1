param($fileName, $root = "")

if ($root -ne "")
{
	Set-Location $root
}

$branch= &git rev-parse --abbrev-ref HEAD 
$gitHist = (git log --format="%ai`t%H`t%an`t%ae`t%s" -n 1) | ConvertFrom-Csv -Delimiter "`t" -Header ("Date","CommitId","Author","Email","Subject")

$infoPath = "_$($fileName).txt";

if (Test-Path $infoPath){
    Remove-Item $infoPath -Force
}


$branch | Out-File $infoPath
$gitHist | Out-File $infoPath -Append