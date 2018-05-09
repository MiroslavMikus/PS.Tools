# Miroslav Mikus 2018/05/09
# 
# This script will take first link from 'git remote -v' 
# and open it in selected browser
# 

param([Parameter(Mandatory=$true)][string]$root,
      [Parameter(Mandatory=$false)][string]$browser)

if($root -eq ""){
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

Write-Host "Opening: $link";

if ($browser -eq ""){

    Start-Process $link
}
else{

    Start-Process -FilePath $browser -ArgumentList $link
}

Write-Host "Script will end in 3 sec";

Start-Sleep -s 3

# Read-Host -Prompt "Done - Press Enter to exit"