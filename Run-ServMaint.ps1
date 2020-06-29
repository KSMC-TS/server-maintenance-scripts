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
#param ([string]$emailaddress=(Read-Host "Enter your email"),[string]$smtpserver="")
#$fromaddress = "$emailaddress" 
#$toaddress = "$emailaddress" 
#$bccaddress = ""
#$CCaddress = ""
#$Subject = "Client Maintenance Report - $date" 
#$body = "Client Maintenance Report Attached"
#$attachment = "$reportspath\maintreport-all-$date.log" 
#$smtpserver = ""
#$credential = Get-Credential -UserName $emailaddress -Message "Please enter your password"
<#
function DownloadFilesFromRepo {
    Param(
        [string]$Owner,
        [string]$Repository,
        [string]$Path,
        [string]$DestinationPath
        )
    
        $baseUri = "https://api.github.com/"
        $args = "repos/$Owner/$Repository/contents/$Path"
        $wr = Invoke-WebRequest -Uri $($baseuri+$args)
        $objects = $wr.Content | ConvertFrom-Json
        $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
        $directories = $objects | where {$_.type -eq "dir"}
        $directories | ForEach-Object { 
            DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
        }
        if (-not (Test-Path $DestinationPath)) {
            # Destination path does not exist, let's create it
            try {
                New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop
            } catch {
                throw "Could not create path '$DestinationPath'!"
            }
        }
        foreach ($file in $files) {
            $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
            try {
                Invoke-WebRequest -Uri $file -OutFile $fileDestination -ErrorAction Stop -Verbose
                "Grabbed '$($file)' to '$fileDestination'"
            } catch {
                throw "Unable to download '$($file.path)'"
            }
        }
    }

#>

    function AnalyzeLogs {
        param($server)
        $scriptfolder = "c:\ksmc\scripts\maint\AnalyzeLogs"

        #if (!(Test-Path $scriptfolder)) {
        #    New-Item -ItemType Directory -Path $scriptfolder
        #
        #}

        $script = "$scriptfolder\FrequencyLog.ps1 -IncludeSecurity -computerp $server"
        [scriptblock]$command = "powershell.exe -command '& $script'"
        Invoke-Command -scriptblock ([scriptblock]::Create($command))
    
    }






$reportspath = "c:\ksmc\scripts\maint\reports"
$scriptpath = "c:\ksmc\scripts\ServerMaint.ps1"
$scripturl = "https://raw.githubusercontent.com/KSMC-TS/server-maintenance-scripts/master/ServerMaint.ps1"
$listpath = "C:\ksmc\scripts\servers.txt"

Write-Host "Recreating Script from Latest"
if ((Test-Path $scriptpath) -eq $True) { Remove-Item $scriptpath -force }
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
    Write-Host "Analyzing Logs on $server"
    AnalyzeLogs -server $server
    Write-Host "Running Maintenance on $Server"
    Invoke-Command -ComputerName $server -ScriptBlock $remoteCommand
    [string]$date = (Get-Date -Format "MMddyyyy")
    $maintlog = (Get-ChildItem "\\$server\c$\ksmc\scripts\maint\maint*$date*.log" )
    Write-Host "Copying Report $maintlog"
    Copy-Item $maintlog $reportspath -Force 

}

Get-Content $reportspath\*.log | Set-Content $reportspath\maintreport-all-$date.log 

#Write-Host "Sending Email"
#Send-MailMessage -SmtpServer $smtpServer -From $fromaddress -To $toaddress -Subject $Subject -Body $body -Attachments $attachment #-UseSsl -Port 587 -Credential $credential