param ($listpath = "C:\ksmc\scripts\servers.txt",[switch]$InstallPS7)

function Install-PS7 {
    param ($listpath = "c:\ksmc\scripts\servers.txt")
    $computers = Get-Content $listpath
    ForEach ($computer in $computers) {
        Write-Output "Deploying PWSH7 on $computer"
        $pwsh = Invoke-Command -Computername $computer -ScriptBlock {Test-Path "$env:ProgramFiles\PowerShell\7"} 
        if (!($pwsh -eq $true)) {
            Invoke-Command -ComputerName $computer {iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"}
        }
    }

}

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
if ($InstallPS7) { 
    Write-Host "Deploying Powershell 7"
    Install-PS7
    Start-Sleep -seconds 30
}

$reportspath = "c:\ksmc\scripts\maint\reports"
$scriptpath = "c:\ksmc\scripts\ServerMaint.ps1"
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
    $pwsh = Invoke-Command -Computername $server -ScriptBlock {Test-Path "$env:ProgramFiles\PowerShell\7"}  
    if ($pwsh -eq $true) {
        $remoteCommand = { 
            pwsh.exe -command "& c:\ksmc\scripts\ServerMaint.ps1"
        }

    } else {
        $remoteCommand = { 
            powershell.exe -command "& c:\ksmc\scripts\ServerMaint.ps1"
        }

    }
    Write-Host "Running Maintenance on $Server"
    Invoke-Command -ComputerName $server -ScriptBlock $remoteCommand
    [string]$date = (Get-Date -Format "MMddyyyy")
    $maintlog = (Get-ChildItem "\\$server\c$\ksmc\scripts\maint\*maint*$date*.log" )
    Write-Host "Copying Report $maintlog"
    Copy-Item $maintlog $reportspath -Force 

}

Write-Host "Creating Master Report..."
Get-Content $reportspath\*maint*$date*.log | Set-Content $reportspath\maintreport-all-$date.log
Write-Host "Script Complete"
