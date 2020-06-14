<#
.SYNOPSIS
   Runs the ServMaint.ps1 script on a list of servers provided via .txt file
.DESCRIPTION

.INPUTS
  
.OUTPUTS

.NOTES
  Version:        1.0
  Author:         Fred Gottman
  Creation Date:  04.05.2020
  Purpose/Change: Initial version
  
  ***** Run-ServMaint Compatible with PS 3.0+ ***********
.EXAMPLE
  
#>

$reportspath = "c:\ksmc\scripts\maint\reports"
$scriptpath = "c:\ksmc\scripts\ServerMaint.ps1"
$scripturl = "https://raw.githubusercontent.com/KSMC-TS/server-maintenance-scripts/master/ServerMaint.ps1"
$listpath = "C:\ksmc\scripts\servers.txt"
if ((Test-Path $scriptpath) -eq $True) {Remove-Item $scriptpath -force}
Invoke-WebRequest $scripturl -OutFile $scriptpath
$savelogs = Read-Host "Do you want to archive event logs? (y or n)"
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
    $remotepath = "\\$server\c$\ksmc\scripts"
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
    $remoteCommand = { 
        Set-Location "c:\ksmc\scripts"
        .\ServerMaint.ps1 -SaveLogs $using:savelogs
    }
    Write-Host "Running Maintenance on $Server"
    Invoke-Command -ComputerName $server -ScriptBlock $remoteCommand
    [string]$date = (Get-Date -Format "MMddyyyy")
    $maintlog = (Get-ChildItem "\\$server\c$\ksmc\scripts\maint\maint*$date*.log" )
    Write-Host "Copying Report $maintlog"
    Copy-Item $maintlog $reportspath -Force
}