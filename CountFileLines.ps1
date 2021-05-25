$sources = "<rootPath>","<rootPaht>"

$lines = @()


$result = $sources | foreach {
    $files = Get-ChildItem -Path $_ -Recurse -Filter $filter -Exclude "*i.cs","*g.cs";
    $count = 0;
    Foreach ( $file in $files)
    {
        $count += (Get-Content $file.FullName | Measure-Object –Line).Lines
    }
    $lines += "$_;$count;$filter"
}

Add-Content C:\S\AllLines.csv $lines


$filter = "*.cs"
$filter = "*.xaml"
$filter = "*.TcPOU"
$filter = "*.ps1"