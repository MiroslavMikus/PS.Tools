$sourceNugetExe = "http://nuget.org/nuget.exe"
$targetNugetExe = "$env:TEMP\nuget.exe"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
$p = Start-Process $targetNugetExe -ArgumentList "install NuGet.CommandLine -Output $env:ProgramData -ExcludeVersion -NonInteractive" -wait -NoNewWindow -PassThru
Remove-Item $targetNugetExe