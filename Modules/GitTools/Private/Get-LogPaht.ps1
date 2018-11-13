function Get-LogPaht {
    param (
        [Parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()] 
        [string]$ScriptName
    )

    $path = "$([Environment]::GetFolderPath('CommonApplicationData'))\PowershellLogs"

    If(!(test-path $path))
    {
        New-Item -ItemType Directory -Force -Path $path
    }
    
    return "$path\$ScriptName.log"
}

function Open-DefaultLogPath{
    explorer.exe "$([Environment]::GetFolderPath('CommonApplicationData'))\PowershellLogs"
}