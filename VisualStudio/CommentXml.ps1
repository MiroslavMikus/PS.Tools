function comment-xmlLine {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xmlLine
    )
    return "<!--$xmlLine-->"
}

function unComment-xmlLine {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xmlLine
    )
    $result = $xmlLine.Replace("<!--", "");
    return $result.Replace("-->", "");
}

function Recognize-CommentToken {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $xmlLine
    )
    return $xmlLine.Contains("[switch]");
}

function CommentIn-Switch {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xmlLine
    )
    return $xmlLine.Replace("[switch]", "<!--[switch]-->" );
}

function Replace-Token {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xmlLine,
        $ReplaceDictionary

    )
    process {
        foreach ($key in $ReplaceDictionary.Keys) {
            $xmlLine = $xmlLine.Replace($key, $ReplaceDictionary[$key]);
        }
    
        return $xmlLine;
    }
}

function Toggle-Comment {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xmlLine
    )
    process {
        if ($(Recognize-CommentToken $xmlLine)) {
            if ($xmlLine.Trim().StartsWith("<!--")) {
                # remove comment
                return $xmlLine | unComment-xmlLine | CommentIn-Switch
            }
            else {
                # add comment
                return $xmlLine | unComment-xmlLine | comment-xmlLine
            }
        }
        else {
            return $xmlLine;
        }
    }
}

function NuGet-SwitchXml {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $xml,
        $ReplaceDictionary
    )
    return $xml.Split([System.Environment]::NewLine) | `
        Replace-Token -ReplaceDictionary $ReplaceDictionary | `
        Toggle-Comment | `
        ForEach-Object `
            { $result = "" } `
            { $result += $_ + [System.Environment]::NewLine } `
            { $result.TrimEnd([System.Environment]::NewLine) };
}

function NuGet-SwitchFile {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ParameterSetName="default")][string[]]
        $Projects,
        [Parameter(Position = 1, ParameterSetName="extendet")][string]
        $RootDir,
        [Parameter(Position = 1, ParameterSetName="extendet")][string]
        $Filter="*.csproj",
        [hashtable]
        $ReplaceDictionary,
        [switch]$WhatIf
    )
    if ($PSCmdlet.ParameterSetName -eq "extendet"){
        $Projects = Get-ChildItem -Path $RootDir -Filter $Filter -Recurse | `
        Select-Object -ExpandProperty FullName 
    }

    foreach ($proj in $Projects) {
        Get-Content -Path $proj -Raw | `
            NuGet-SwitchXml -ReplaceDictionary $ReplaceDictionary | `
            Set-Content -Path $proj -WhatIf:$WhatIf
    }   
}