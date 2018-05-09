# Miroslav Mikus 2018/05/09
# 
# This script will take first link from 'git remote -v' 
# and open it in selected browser
# 

param([Parameter(Mandatory=$false)][string]$browser)


$localRemote = (git remote -v)

$link = SearchLink($localRemote[0]);

if ($browser -eq ""){

    Start-Process -FilePath $browser -ArgumentList $link
}
else{
    Start-Process $link
}

function SearchLink ([string]$data) {

    $startPosition = $data.IndexOf("http");
    
    $endPosition = $data.IndexOf("(");
    
    return $data.Substring($startPosition, $endPosition - $startPosition);
}