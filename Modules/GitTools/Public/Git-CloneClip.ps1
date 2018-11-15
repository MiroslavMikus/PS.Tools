# Miroslav Mikus 2018/04/26
# 
# Clone git url form clipboard to $root
# 

function Git-CloneClip {
    param (
        [string]$root
    )
    
}

#region import logger
$scriptPath = (split-path $MyInvocation.MyCommand.Path);
$scriptParent = (get-item $scriptPath).Parent.FullName
$loggerPath = $scriptParent + "\Shared\Logger.ps1";
$logPath = "$scriptPath\Log\$($MyInvocation.MyCommand.Name).log";
. $loggerPath;
#endregion

if($root -eq ""){
    
    Write-log "Root parameter is missing" -Path $logPath -Level Error
    
    Read-Host -Prompt "Press Enter to exit"
    
    return;
}

$clip = get-clipboard;

Write-log "Clip: $clip" -Path $logPath 

Set-Location $root;

Write-log "Run: git clone $clip" -Path $logPath 

git clone $clip

Write-Host "Done - Script will end in 4 sec";

Start-Sleep -s 4