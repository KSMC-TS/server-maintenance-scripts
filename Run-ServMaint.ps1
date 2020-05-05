<#
.SYNOPSIS
   
.DESCRIPTION

.INPUTS
  
.OUTPUTS

.NOTES
  Version:        1.0
  Author:         Fred Gottman
  Creation Date:  04.05.2020
  Purpose/Change: Initial version
  
.EXAMPLE
  
#>

$reportspath = "c:\ksmc\scripts\maint\reports"
$scriptpath = "c:\ksmc\scripts\ServerMaint.ps1"
$listpath = "C:\ksmc\scripts\servers.txt"
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
        Write-Verbose "($remotescript) already exists" -Verbose 
    } else { 
        New-Item -ItemType Directory -Path $remotepath
        copy-item $scriptpath $remotescript
        Write-Verbose "($remotepath) was created" -Verbose 
    }    
    $remoteCommand = { 
        powershell.exe "C:\ksmc\scripts\ServerMaint.ps1"
    }
    Write-Host "Running Maintenance on $Server"
    Invoke-Command -ComputerName $server -ScriptBlock $remoteCommand
    $maintlog = (Get-ChildItem "\\$server\c$\ksmc\scripts\maint\maint*.log" )
    Write-Host "Copying Report $maintlog"
    Copy-Item $maintlog $reportspath -Force
}