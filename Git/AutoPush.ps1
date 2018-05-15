# Miroslav Mikus 2018/03/04
# 
# Executes Git status Commit & Push
# Enter empty message to stop the script
# 

param([string]$root)

if($root -eq ""){

    Read-Host -Prompt "Root parameter is missing - Press Enter to exit"

    return;
}

Set-Location $root

git status

Write-Host "######"
Write-Host "Git add -A; commit; push is following"
Write-Host "######"

$name = Read-Host -Prompt "Enter Commit message:"

if ($name -eq "") {
    return;
}

git add -A

git commit -m "$name"

git push

Read-Host -Prompt "Done - Press Enter to exit"