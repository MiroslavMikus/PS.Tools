# Miroslav Mikus 2018/03/04
# 
# Opens first *.sln file from root directory
# 

param([string]$root)

# Test
# $root = "C:\S\Serva.Customers.Audi.Brussels.ControlTower"

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

Write-log "Starting with folder: $root" -Path $logPath 

Set-Location $root

$slnFile = Get-ChildItem -Path $root -Filter *.sln -Recurse -ErrorAction SilentlyContinue -Force

if($slnFile.Count -eq 0){
    Write-log "Solution file was not found" -Path $logPath 
}
else {
    Write-log ("Opening file "+ $slnFile[0].FullName) -Path $logPath 
    Start-Process $slnFile[0].FullName
}
