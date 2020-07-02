    <#

    .DESCRIPTION
    Deploy PowerShell Core:latest from Microsoft

    .PARAMETER listpath
    List of computers to deploy to - default is 'c:\ksmc\scripts\servers.txt'
    Create .txt file, list one hostname on each line to run against

    .PARAMETER basepath
    Base location for Output folder - default is 'c:\ksmc\scripts'

    .PARAMETER DeployPSCore
    Optional parameter to deploy the latest version (currently 7.0.2) of PowershellCore to the same list from 'listpath'
    If servers are running PSCore(6.0+), Maintenance Scripts will run in PSCore [pwsh.exe] instead of Powershell [powershell.exe]

    .EXAMPLE
    Recommended running method: Open ISE as admin, open script and run

    .NOTES
    

    #>

param (
        $listpath = "C:\ksmc\scripts\servers.txt", ## can be located anywhere
        [switch]$DeployPSCore,
        $basepath = "c:\ksmc\scripts" ## must be on c:\
        )

    function Deploy-PSCore {
        param (
            [Parameter(Mandatory=$true,
            ValueFromPipeline=$true)]
            [String[]] $listpath
            )
        $computers = Get-Content $listpath
        ForEach ($computer in $computers) {
            Write-Output "Deploying PowerShellCore:Latest on $computer"
            Invoke-Command -ComputerName $computer {iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"}
        }
    }


if ($DeployPSCore) { 
    Write-Host "Deploying PowershellCore:Latest"
    Deploy-PSCore -listpath $listpath
    Start-Sleep -seconds 30
}

$dirpath = $basepath.Substring(3) ## base path, removing c:\
$reportspath = "$basepath\maint\reports"
$scriptpath = "$basepath\ServerMaint.ps1"
$scripturl = "https://raw.githubusercontent.com/KSMC-TS/server-maintenance-scripts/main/ServerMaint.ps1"

Write-Host "Recreating Script from Latest"
if ((Test-Path $scriptpath) -eq $True) { Remove-Item $scriptpath -force }
Invoke-WebRequest $scripturl -OutFile $scriptpath
[string]$scriptlastwrite = Get-ChildItem $scriptpath | Select-Object LastWriteTime
$pathexists = Test-Path $reportspath
if ($pathexists -eq $True) { 
    Write-Verbose "($reportspath) already exists" -Verbose 
} else { 
    New-Item -ItemType Directory -Path $reportspath -Force
    Write-Verbose "($reportspath) was created" -Verbose 
}   

$servers = Get-Content $listpath 

foreach ($server in $servers) { 
    $remotebase = "\\$server\c$"  
    $remotepath = "$remotebase\$dirpath"
    $remotescript = "$remotepath\ServerMaint.ps1"
    $scriptexists = Test-Path $remotescript
    if ($scriptexists -eq $True) { 
        Write-Verbose "($remotescript) already exists, checking version" -Verbose
        [string]$remotescriptlastwrite = Get-ChildItem $remotescript | Select-Object LastWriteTime
        if ($remotescriptlastwrite -lt $scriptlastwrite) {
            Write-Host "Script is outdated, copying latest"
            Remove-Item $remotescript -Force
            copy-item $scriptpath $remotescript -Force
        } else {
            Write-Host "Script is the same, skipping"
        }
    } else { 
        New-Item -ItemType Directory -Path $remotepath
        copy-item $scriptpath $remotescript -Force
        Write-Verbose "($remotepath) was created" -Verbose 
    }
    $pwsh = Invoke-Command -Computername $server -ScriptBlock {Test-Path "$env:ProgramFiles\PowerShell\*"}  
    if ($pwsh -eq $true) {
        Write-Output "Running in Powershell Core (6.0+)"
        $remoteCommand = { 
            pwsh.exe -command "& $using:scriptpath -basepath $using:basepath"
        }
    } else {
        Write-Output "Running in Powershell (up to 5.1)"
        $remoteCommand = { 
            powershell.exe -command "& $using:scriptpath -basepath $using:basepath"
        }
    }
    Write-Host "Running Maintenance on $Server"
    Invoke-Command -ComputerName $server -ScriptBlock $remoteCommand
    [string]$date = (Get-Date -Format "MMddyyyy")
    $maintlog = (Get-ChildItem "$remotepath\maint\*maint*$date*.log" )
    Write-Host "Copying Report $maintlog"
    Copy-Item $maintlog $reportspath -Force 

}

Write-Host "Creating Master Report..."
Get-Content $reportspath\*maint*$date*.log | Set-Content $reportspath\maintreport-all-$date.log
Write-Host "Script Complete"
