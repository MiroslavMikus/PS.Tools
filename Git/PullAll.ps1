# Miroslav Mikus 2018/04/26
# 
# Pull for each directory in $root directory
# 

param([string]$root)

#test
#$root = "C:\S";

if ($root -eq "") 
{
    Write-Host "Root cannot be empty!"
    
    Read-Host -Prompt "Script will exit"
    
    return;
}

$dir = Get-ChildItem $root | Where-Object {$_.PSISContainer} | select-object FullName

$count = $dir.Count;
$current = 0;

# make space for progressbar
for ($i = 0; $i -lt 5; $i++) {
    Write-Host $([Environment]::Newline);
}

foreach ($d in $dir) 
{
    $current++;

    [int]$currentProgress = $current / ($count / 100) ;

    Write-Progress -Activity "Pull in all folders" -Status "$currentProgress% Complete:" -PercentComplete $currentProgress;

    Write-Host ("###### git pull --all -> " + $d.FullName);

    Set-Location $d.FullName;

    git pull --all
}

Read-Host -Prompt "Done - Press Enter to exit"