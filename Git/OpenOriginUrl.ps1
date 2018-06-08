# Miroslav Mikus 2018/05/09
# 
# This script will take first link from 'git remote -v' 
# and open it in selected browser
# 

param([Parameter(Mandatory=$true)][string]$root,
      [Parameter(Mandatory=$false)][string]$browser)

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

function SearchLink ([string]$data) {

    $startPosition = $data.IndexOf("http");
    
    $endPosition = $data.IndexOf("(");
    
    return $data.Substring($startPosition, $endPosition - $startPosition);
}

Set-Location $root

$localRemote = (git remote -v)

$link = SearchLink($localRemote[0]);


if ($browser -eq ""){
    
    Write-log "Opening: $link" -Path $logPath 

    Start-Process $link
}
else{

    Write-log "Opening with $browser : $link" -Path $logPath 
    
    Start-Process -FilePath $browser -ArgumentList $link
}

Write-Host "Script will end in 3 sec";

Start-Sleep -s 3
