$update =
{
    param ([string]$rootDirectory, [string]$name, [string]$version)

    function UpdateSolutionNuget([string]$rootDirectory, [string]$name, [string]$version) {
        Set-Location $rootDirectory
        
		# All projecto must have either packages.config or packagereference
        $project = Get-ChildItem -Path $rootDirectory -Filter "*.csproj" -Recurse | Select-Object -First 1
        
        $configExist = (Test-Path -Path (Join-Path $project.DirectoryName "packages.config"))
        
        if ($configExist) {
            Write-Host "Updating with nuget.exe" -ForegroundColor Yellow
            UpdateNuget $rootDirectory $name $version
        }
        else {
            Write-Host "Updating with dotnet.exe" -ForegroundColor Yellow
            UpdateDotNetNuget $rootDirectory $name $version
        }
    }
    
    function UpdateNuget([string]$rootDirectory, [string]$name, [string]$version) {
        Set-Location $rootDirectory
        $solution = Get-ChildItem $rootDirectory -Filter *.sln | Select-Object -First 1
        Invoke-Expression "nuget update $solution -Id $name -Version $version"
    }
    
    function UpdateDotNetNuget([string]$rootDirectory, [string]$name, [string]$version) {
        $regex = [regex] 'PackageReference Include="{0}"' -f $name
        
        ForEach ($file in Get-ChildItem $rootDirectory -recurse | Where-Object { $_.extension -like "*proj" }) {
            $proj = $file.fullname;
			
            $content = Get-Content $proj
			
			# Since there is no update:
			# 1. Check if is the curent nuget installed
			# 2. If $true -> uninstall the old one and install it again with the specified $version
            $result = $content -match $regex
			
            if ('' -notlike $result) {
                # hardcore hack here
                Invoke-Expression "dotnet remove $proj package $name"
                # update the actual nuget
                Invoke-Expression "dotnet add $proj package $name -v $version"
            }
        }
    }

    UpdateSolutionNuget $rootDirectory $name $version
    #Start-Sleep -Seconds 5
}
    
class NugetDefinition {
    [string]$Name
    [string]$Version
    NugetDefinition($name, $version) {
        $this.Name = $name;
        $this.Version = $version;
    }
}

function InvokeNugetUpdate([string[]] $solutions, [NugetDefinition[]]$nugets) {
    foreach ($solution in $solutions) {
        Set-Location $solution
    
        $status = (Invoke-Expression "git status");
		
		# Revert changes from the precious run
        # git reset --hard
    
		# I want start with clean working tree
        if ($status -notcontains "nothing to commit, working tree clean") {
            Write-Host "Repository $solution is not clean! Either commit your changes or remove them!" -ForegroundColor Red
            return;
        }

        Write-Host "Pulling latest changes for $solution repository!" -ForegroundColor Green
    
        Invoke-Expression "git pull"
    }
    
    $startTime = Get-Date
    
	# Each nuget will create one job for each solution
    foreach ($nuget in $nugets) {
	
        $jobLookups = @()

        foreach ($solution in $solutions) {
            Write-Host $solution $nuget.Name $nuget.Version -ForegroundColor Yellow
            $job = start-job -scriptblock $update -ArgumentList @($solution, $nuget.Name, $nuget.Version)
            $jobLookups += New-Object psobject -Property @{Job = $job; Solution = $solution };
        }

        Write-host "Working on $($jobLookups.count) jobs!" -ForegroundColor Yellow
        
        $jobLookups | Select-Object Job | Wait-Job | Out-Null;

		# This will calculate the execution time for each job
        foreach ($jobLookup in $jobLookups) {
            $jobMinutes = [math]::Round(($jobLookup.Job.PSEndTime.TimeOfDay - $jobLookup.Job.PSBeginTime.TimeOfDay).TotalMinutes, 2)
            Write-Host "$($jobLookup.Solution) was done in $jobMinutes min";
        }

		# And calculation for the grand total
        $currentTime = NEW-TIMESPAN –Start $startTime –End (Get-Date)
        $currentTime = [math]::Round($currentTime.TotalMinutes, 2)
        Write-Host "Current time: $currentTime min." -ForegroundColor Green
    }
    
    Write-host "### Done ###" -ForegroundColor Yellow
}

# Nuget ID with the version
$nugets = @(
    [NugetDefinition]::new("Serilog","2.9.0"),
    [NugetDefinition]::new("Autofac","5.1.1"),
)

# Solution working directory
$solutions = @(
    "C:\S\Client",
    "C:\S\Server",
	"C:\S\Plugins"
)

# This will execute all the magic
InvokeNugetUpdate $solutions $nugets

function OpenSolutions ([string[]]$directory){
    foreach ($dir in $directory) {
        $result = Read-Host "Open $dir [y]"
        if ($result -eq "y"){
            $sln = (Get-ChildItem $dir -Filter *.sln | Select-Object -First 1).fullname
            Invoke-Expression $sln
        }
    }
}

# OpenSolutions $solutions
