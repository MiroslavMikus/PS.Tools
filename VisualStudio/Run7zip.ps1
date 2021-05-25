param($root, $files)

Write-Host "Root:"
Write-Host $root
Write-Host "Files:"
Write-Host $files

#$root = "C:\S\.Porsche\Zuffenhausen.J1.ControlTower\J1.ControlTower.SAP\bin\Debug"
#$files = "EntityFramework.dll Serva.Ba se.Api.Sap.dll";

$preifx = Read-Host "Enter file prefix:"

$fileName = $preifx+"_$(Get-Date -Format yyyy-MM-dd_HH-mm-ss).7z"

$target = Join-Path $root $fileName

Write-Host $target

Write-Host "7z a $target $files"

7z a $target @$files