param([string]$prefix = "")

if ($prefix -eq "")
{
	$preifx = Read-Host "Enter file prefix:"
}

$fileName = $preifx+"_$(Get-Date -Format yyyy-MM-dd_HH-mm-ss).7z"

Write-Host "7z a $target $files"

7z a $fileName *.* -x!*7z