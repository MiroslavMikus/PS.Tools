Add-Type -Path .\Serilog.dll
Add-Type -Path .\Serilog.Sinks.File.dll

$Config = New-Object Serilog.LoggerConfiguration;

$SinkConfig = $Config.WriteTo;

$logger = [Serilog.FileLoggerConfigurationExtensions]::File($SinkConfig, "test")

$Config = New-Object Serilog.LoggerConfiguration
[Serilog.Configuration.LoggerSinkConfiguration]$ConfigSink = $config.WriteTo;
[Serilog.Log]::Logger = [Serilog.FileLoggerConfigurationExtensions]::File($ConfigSink, "test.txt").CreateLogger();

[Serilog.Log]::Information("Logging started")

$source = @"
public class LoggerSetup
{
    public Serilog.ILogger Logger { get; set; }

    public LoggerSetup()
    {
        Assembly assembly = Assembly.LoadFrom("MyNice.dll");
        //Logger = new LoggerConfiguration().WriteTo.File("TestShit").CreateLogger();
    }
}
"@

Add-Type -TypeDefinition $source

$source = @"
public class BasicTest
{
  public static int Add(int a, int b)
    {
        return (a + b);
    }
  public int Multiply(int a, int b)
    {
    return (a * b);
    }
}
"@

Add-Type -TypeDefinition $source

[BasicTest]::Add(4, 3)

$basicTestObject = New-Object BasicTest

$basicTestObject.Multiply(5,100)

<# 
.Synopsis 
   Write-Log writes a message to a specified log file with the current time stamp. 
.DESCRIPTION 
   The Write-Log function is designed to add logging capability to other scripts. 
   In addition to writing output and/or verbose you can write to a log file for 
   later debugging. 
.PARAMETER Message 
   Message is the content that you wish to add to the log file.  
.PARAMETER Path 
   The path to the log file to which you would like to write. By default the function will  
   create the path and file if it does not exist.  
.PARAMETER Level 
   Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational) 
.PARAMETER NoClobber 
   Use NoClobber if you do not wish to overwrite an existing file. 
.EXAMPLE 
   Write-Log -Message 'Log message'  
   Writes the message to c:\Logs\PowerShellLog.log. 
.EXAMPLE 
   Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log 
   Writes the content to the specified log file and creates the path and file specified.  
.EXAMPLE 
   Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error 
   Writes the message to the specified log file as an error message, and writes the message to the error pipeline. 
#> 
function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path='C:\Logs\PowerShellLog.log', 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}

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