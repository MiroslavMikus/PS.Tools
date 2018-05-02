# Miroslav Mikus 2018/03/04
# 
# Executes Git Commit & Push
# 

param([string]$root)

if($root -eq ""){
    return;
}

Set-Location $root

$name = Read-Host -Prompt "Enter Commit message:"

if ($name -eq "") {
    return;
}

git add -A

git commit -m "$name"

git push

Read-Host -Prompt "Done - Press Enter to exit"