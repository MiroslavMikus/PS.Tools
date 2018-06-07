# Miroslav Mikus 2018/04/26
# 
# Clone git url form clipboard to $root
# 

param([string]$root)

if ($root -eq "") 
{
    Write-Host "Root cannot be empty!"
    
    Read-Host -Prompt "Script will exit"
    
    return;
}

$clip = get-clipboard;

Write-Host "Clip: $clip"

Set-Location $root;

Write-Host "Run: git clone $clip"

git clone $clip

Write-Host "Done - Script will end in 4 sec";

Start-Sleep -s 4