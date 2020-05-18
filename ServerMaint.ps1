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
param([string]$savelogs='n')

#Checks if the session is being run as Admin (Some of the values won't populate without it)
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

function Get-HWInfo {
    param ($computername = $env:COMPUTERNAME,[string]$PSVer)
    if ($PSVer -ge "5") {
        [hashtable]$HWInfo = @{}
        $HWType = (Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Computername | Select-Object Manufacturer,Model)
        $Serial = (Get-CimInstance -Class Win32_bios -ComputerName $Computername | Select-Object SerialNumber | Select-Object -ExpandProperty SerialNumber)
        $activation = (Get-CimInstance SoftwareLicensingProduct -ComputerName $env:computername -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" |  Where-Object licensestatus -eq 1  | Select-Object Name, Description)
        if ($activation) {$HWInfo.LicAct = "True"} else {$HWInfo.LicAct = "False"}
        if ($HWType.Model -like "*Virt*") {$VM = "True"} else { $VM = "False"}
        $HWInfo.VM = $VM
        $HWInfo.Serial = $Serial
        $HWInfo.LicName = $activation.Name
        $HWInfo.LicDesc = $activation.Description
        $HWInfo.Mfg = $HWType.Manufacturer
        $HWinfo.Model = $HWType.Model
    } else {
        [hashtable]$HWInfo = @{}
        $HWType = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computername | Select-Object Manufacturer,Model)
        $Serial = (Get-WmiObject -Class Win32_bios -ComputerName $Computername | Select-Object SerialNumber)
        $activation = (Get-WmiObject SoftwareLicensingProduct -ComputerName $env:computername -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" |  Where-Object licensestatus -eq 1  | Select-Object Name, Description)
        if ($activation) {$HWInfo.LicAct = "True"} else {$HWInfo.LicAct = "False"}
        if ($HWType.Model -like "*Virt*") {$VM = "True"} else { $VM = "False"}
        $HWInfo.VM = $VM
        $HWInfo.Serial = $Serial
        $HWInfo.LicName = $activation.Name
        $HWInfo.LicDesc = $activation.Description
        $HWInfo.Mfg = $HWType.Manufacturer
        $HWinfo.Model = $HWType.Model
    }
    return $HWInfo

}
#Gets IP & MAC
function Get-NetInfo{ 
    param ($computername = $env:COMPUTERNAME) 
    $netadapters = ( Get-CimInstance -class "Win32_NetworkAdapterConfiguration" -computername $computername | Where-Object {$_.IPEnabled -Match "True"} )
    foreach ($netadapter in $netadapters) {  
        $netadapter | Select-Object -Property Description,MacAddress,IPAddress 
    }  
}
#Archives the App, Sec, And Sys, event logs and clears the logs 
Function Get-EventArchive{            
    Param(
        $Computername = $ENV:COMPUTERNAME,
        [array]$EventLogs = @("application","security","system"),
        $BackupFolder = "$logpath"
    )        
    Foreach ( $log in $EventLogs ) {
        If(!( Test-Path $BackupFolder )){ 
            New-Item $BackupFolder -Type Directory
        }
        $eventlog="$BackupFolder\$log" + "-" + (Get-Date -Format "MMddyyyy-HHmmss") + ".evt"
        (Get-CimInstance win32_nteventlogfile -ComputerName $computername | Where-Object {$_.logfilename -eq "$log"}) | Invoke-CimMethod -MethodName backupeventlog -Arguments @{ArchiveFileName=$eventlog}            
        [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog("$log")            
    }          
}


# Get Scheduled tasks  -add on output for display
Function Get-SchTasks {
    $schtasks = @(Get-ScheduledTask -TaskPath \ | Get-ScheduledTaskInfo )
    $schtaskstatus = @()
    foreach ($task in $schtasks) { 
        switch ($task.LastTaskResult) {
            "0" {$taskstatus = "Operation Completed Successfully"}
            "267011" {$taskstatus = "Task has not yet run"}
            default {$taskstatus = "Unknown code"}
        }
        $st = [ordered]@{}
        $st.'Name' = $task.TaskName.SubString(0, [Math]::Min($task.TaskName.Length, 20))
        $st.'Last Run' = $task.LastRunTime
        $st.'Last Result' = $taskstatus
        $st.'Missed Runs' = $task.NumberOfMissedRuns
        $st.'Next Run' = $task.NextRunTime
        $SchtaskStatus += New-Object -TypeName PSObject -Property $st
    }
    $schtaskstatusall = $schtaskstatus | Sort-Object -Property Name 
    return $schtaskstatusall
}


# Check NTP   -add on output for display
Function Get-NTPConfig {
    $ntp = w32tm /query /status
    return $ntp
}


# Check expiring certs, today +1 month
Function Get-Certs {
    $certs  = (Get-ChildItem cert:\LocalMachine -Recurse -EA SilentlyContinue | Where-Object { $_.NotAfter -gt (Get-Date) -and $_.NotAfter -lt (Get-Date).AddMonths(1) } | Select-Object -Property FriendlyName,NotAfter,Subject,Issuer,EnhancedKeyUsageList )
    if ($certs) { 
        return $certs 
    } else {
        $certs = "No certs expiring in the next 30 days"
        return $certs
    }
}

#System Uptime            
Function Get-SrvUptime {
    param ([string]$ComputerName = $env:COMPUTERNAME,[string]$PSVer)
    if ($PSVer -ge "6") {
        $Uptime = Get-UpTime -Since
    } elseif ($PSVer -eq "5") {
        $Uptime = Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime | Select-Object -ExpandProperty LastBootUpTime
        
    } else {
        $System = Get-WmiObject win32_operatingsystem
        $Uptime =  $System.ConvertToDateTime($System.LastBootUpTime)
    }
    Return $Uptime
}

#PS Version 
Function Get-PSVersion {
    param ([string]$ComputerName = $env:COMPUTERNAME)
    [hashtable]$ReturnPSVer = @{}
    $PSVer = $psversiontable
    if ($PSVer.PSEdition) {
    $ReturnPSVer.PSEd = $PSVer.PSEdition
    } else {
    $ReturnPSVer.PSEd = "No Edition Listed"
    }
    $PSVerMaj = $PSVer.PSVersion.Major
    $ReturnPSVer.PSVer = $PSVer.PSVersion
    $ReturnPSVer.PSMaj = $PSVerMaj
    Return $ReturnPSVer
}

#Grabs info for any local disk
function Get-DiskInfo {
param ([string]$ComputerName = $env:COMPUTERNAME,[string]$PSVer,[string]$IsVirt)
if (($PSVer -ge "5") -and ($IsVirt -eq "True") ) {
    $Volume = Get-CimInstance -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    [hashtable]$DiskFrag = @{}
    $DiskFrag.DefragRecommended = "Virt-Skipping" 
    $DiskInfo = Get-CimInstance -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Defrag Recommended?";e={"{0:n2}" -f $DiskFrag.DefragRecommended}}    
} elseif (($PSVer -ge "5") -and ($IsVirt -eq "False") ) { 
    $Volume = Get-CimInstance -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    $DiskFrag = ( $Volume | Invoke-CimMethod -MethodName defraganalysis -Arguments @{defraganalysis=$volume} | Select-Object -property DefragRecommended, ReturnValue ) 
    $DiskInfo = Get-CimInstance -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Defrag Recommended?";e={"{0:n2}" -f $DiskFrag.DefragRecommended}}    
} elseif (($PSVer -lt "5") -and ($IsVirt -eq "False") ) {
    $Volume = GWMI -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    $DiskFrag = $Volume.DefragAnalysis().DefragAnalysis
    $DiskInfo = GWMI -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Fragmentation";e={"{0:n2}" -f $DiskFrag.TotalPercentFragmentation}}
} elseif (($PSVer -lt "5") -and ($IsVirt -eq "True") ) {
    $Volume = GWMI -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    [hashtable]$DiskFrag = @{}
    $DiskFrag.TotalPercentFragmentation = "Virt-Skipping" 
    $DiskInfo = GWMI -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Fragmentation";e={"{0:n2}" -f $DiskFrag.TotalPercentFragmentation}}
}
return $DiskInfo
}

#Pull antivirus info from the registry
function Get-AV {
    [CmdletBinding()]
    param ([string]$ComputerName = $env:COMPUTERNAME,[string]$PSVer)  
    if ($PSVer -ge "5") {
        [string]$OSVersion = (Get-CimInstance win32_operatingsystem -computername $Computer).Caption
        if (($OSVersion -like "*Windows 10*") -OR ($OSVersion -like "*Windows 7*") -OR ($OSVersion -like "*Windows 8*")) {
            $AntiVirusProducts = Get-CimInstance -Namespace "root\SecurityCenter2" -Class AntiVirusProduct  -ComputerName $computername
            $AvStatus = @()
            foreach($AntiVirusProduct in $AntiVirusProducts){
                switch ($AntiVirusProduct.productState) {
                "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                default {$defstatus = "Unknown" ;$rtstatus = "Inactive"}
                }
                $ht = @{}
                $ht.Name = $AntiVirusProduct.displayName
                $ht.'Product Executable' = $AntiVirusProduct.pathToSignedProductExe
                $ht.'Reporting Exe' = $AntiVirusProduct.pathToSignedReportingExe
                $ht.'Definition Status' = $defstatus
                $ht.'Real-time Protection Status' = $rtstatus
                $AVStatus += New-Object -TypeName PSObject -Property $ht 
            }
        } elseif (($OSVersion -like "*Server*2016*") -OR ($OSVersion -like "*Server*2019*")) {
            $osversion = $OSVersion
            $AVResults = Get-MpComputerStatus | Select-Object -Property Antivirusenabled,AMServiceEnabled,AntispywareEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled,OnAccessProtectionEnabled,RealTimeProtectionEnabled,AntivirusSignatureLastUpdated
            $AVProduct = if ((Test-Path -Path 'C:\Program Files\*' -Include ('*Sophos*')) -eq "True") { "Sophos" } elseif ((Test-Path -Path 'C:\Program Files\*' -Include ('*Trend*')) -eq "True") { "Trend" } elseif ((Test-Path -Path 'C:\Program Files\*' -Include ('*Symantec*')) -eq "True") { "Symantec" } else {"Windows Defender or Unknown Product"}
            $serveros = $OSVersion
            $ht = [ordered]@{}
            $ht.'Server OS' = $serveros
            $ht.'AV Product' = $AVProduct
            $ht.'Anti-Virus Enabled' = $AVResults.Antivirusenabled
            $ht.'Anti-Malware Enabled' = $AVResults.AMServiceEnabled
            $ht.'Anti-Spyware Enabled' = $AVResults.AntispywareEnabled
            $ht.'Behavior-Monitor Enabled' = $AVResults.BehaviorMonitorEnabled
            $ht.'IOAV Protection Enabled' = $AVResults.IoavProtectionEnabled
            $ht.'NIS Enabled' = $AVResults.NISEnabled
            $ht.'On Access Protection Enabled' = $AVResults.OnAccessProtectionEnabled
            $ht.'Real Time Protection Enabled' = $AVResults.RealTimeProtectionEnabled
            $ht.'Anti-Virus Signature Last Updated' = $AVResults.AntivirusSignatureLastUpdated
            $AVStatus = New-Object -TypeName PSObject -Property $ht
        } elseif (($OSVersion -like "*Server*2012*") -OR ($OSVersion -like "*Server*2008*")) {
            $AVStatus = "Can't Detect - Server 2008/2012 unsupported"
        } else {
            $AVStatus = "Can't Detect OS Version - PS 5+"
        }
    } else {
        [string]$OSVersion = (Get-WmiObject win32_operatingsystem -computername $Computer).Caption
        if (($OSVersion -like "*Windows 7*") -OR ($OSVersion -like "*Windows 8*")) {
            $AntiVirusProducts = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct  -ComputerName $computername
            $AvStatus = @()
            foreach($AntiVirusProduct in $AntiVirusProducts){
                switch ($AntiVirusProduct.productState) {
                "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                default {$defstatus = "Unknown" ;$rtstatus = "Inactive"}
                }
                $ht = @{}
                $ht.Name = $AntiVirusProduct.displayName
                $ht.'Product Executable' = $AntiVirusProduct.pathToSignedProductExe
                $ht.'Reporting Exe' = $AntiVirusProduct.pathToSignedReportingExe
                $ht.'Definition Status' = $defstatus
                $ht.'Real-time Protection Status' = $rtstatus
                $AVStatus += New-Object -TypeName PSObject -Property $ht 
                
            }
        } elseif (($OSVersion -like "*Server*2003*") -OR ($OSVersion -like "*Server*2000*") -OR ($OSVersion -like "*Windows XP*")) {
            $AntiVirusProducts = Get-WmiObject -Namespace "root\SecurityCenter" -Class AntiVirusProduct  -ComputerName $computername
            $AvStatus = @()
            foreach($AntiVirusProduct in $AntiVirusProducts){
                switch ($AntiVirusProduct.productState) {
                "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
                "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
                "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
                "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
                default {$defstatus = "Unknown" ;$rtstatus = "Inactive"}
                }
                $ht = @{}
                $ht.Name = $AntiVirusProduct.displayName
                $ht.'Product Executable' = $AntiVirusProduct.pathToSignedProductExe
                $ht.'Reporting Exe' = $AntiVirusProduct.pathToSignedReportingExe
                $ht.'Definition Status' = $defstatus
                $ht.'Real-time Protection Status' = $rtstatus
                $AVStatus += New-Object -TypeName PSObject -Property $ht 
            }
        } elseif (($OSVersion -like "*Server*2012*") -OR ($OSVersion -like "*Server*2008*")) {
            $AVStatus = "Can't Detect - Server 2008/2012 unsupported"
        } else {
            $AVStatus = "Can't Detect OS Version - PS < 5"
        }
        
    }
    Return $AVStatus
}

#Data Gathering and Report Building
function Start-Maintenance{
    [Cmdletbinding()]
    param([string]$Computername,[string]$savelogs)
    $date = Get-Date
    $maintpath = "c:\ksmc\scripts\maint"
    $logpath = "$maintpath\logs"
    $maintfile = "maintenance_report-$env:COMPUTERNAME-"+(Get-Date -Format "MMddyyyy")+".log"
    $maintlog = "$maintpath\$maintfile"
    $pathexists = Test-Path $logpath
    if ($pathexists -eq $True) { 
        Write-Verbose "($logpath) already exists" -Verbose 
    } else { 
        New-Item -ItemType Directory -Path $logpath -Force
        Write-Verbose "($logpath) was created" -Verbose 
    }   
    $(
        $PSVerSummary = Get-PSVersion
        $PSInfoVer = $PSVerSummary.PSVer.ToString()
        $PSInfoEd = $PSVerSummary.PSEd.ToString()
        $PSMaj = $PSVerSummary.PSMaj
        $services = Get-Service
        $os = (Get-CimInstance win32_operatingsystem -computername $Computer).Caption
        $runningsvc = $services | Where-Object {$_.Status -eq "running"}
        $stoppedsvc = $services | Where-Object {$_.Status -eq "stopped"}
        $autosvc = $services | Where-Object {$_.StartType -eq "automatic" -and $_.Status -eq "stopped"} | Select-Object @{Name='Service Name'; Expression={$_.DisplayName}}, Status
        $HWInfoSummary = Get-HWInfo -PSVer $PSMaj
        $HWModel = $HWInfoSummary.Model
        $HWVM = $HWInfoSummary.VM
        $HWMFG = $HWInfoSummary.Mfg
        $HWSN = $HWInfoSummary.Serial
        $HWLICNAME = $HWInfoSummary.LicName
        $HWLICDESC = $HWInfoSummary.LicDesc
        $HWLICACT = $HWInfoSummary.LicAct
        $NetInfo = Get-NetInfo
        $DiskSummary = Get-DiskInfo -PSVer $PSMaj -IsVirt $HWVM
        $AVSummary = Get-AV -PSVer $PSMaj
        $CertSummary = Get-Certs
        $NTPSummary = Get-NTPConfig
        $SchTaskSummary = Get-SchTasks -PSVer $PSMaj
        $lastboot = Get-SrvUptime -PSVer $PSMaj
        Write-Output "******Maintenance Report******"
        Write-Output "Current Date: $date"
        Write-Output "System Name:  $env:COMPUTERNAME"
        Write-Output "Mfg: $HWMFG; Model: $HWModel"
        Write-Output "Serial: $HWSN"
        Write-Output "Activated: $HWLICACT"
        Write-Output "Lic Name: $HWLICNAME"
        Write-Output "Lic Desc: $HWLICDESC"
        Write-Output "Virtual: $HWVM"
        Write-Output "OS: $os"
        Write-Output "PS Version: $PSInfoVer $PSInfoEd"
        Write-Output "Last Boot: $lastboot"
        $uptime = (Get-Date) - ($lastboot)
        $UptimeDisplay = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
        if ($uptime.Days -ge "30") { Write-Output "$uptimedisplay ***NEEDS REBOOT***"  } Else {Write-Output "$uptimedisplay" }
        Write-Output `n
        Write-Output ":::NTP Status:::" 
        $NTPSummary 
        Write-Output `n
        Write-Output ":::Certs expiring within 1 month:::"
        $CertSummary | Format-List
        Write-Output `n
        Write-Output ":::Services Summary:::"
        Write-Output "Services Running:" $runningsvc.Count
        Write-Output "Services Stopped:" $stoppedsvc.Count
        Write-Output `n
        Write-Output "Automatic Services Not Running:"
        $autosvc | Format-Table
        Write-Output ":::Network Adapters:::"
        $NetInfo | Format-Table
        Write-Output ":::Disk Info:::"
        $DiskSummary | Format-Table
        Write-Output ":::Anti-Virus Summary:::"
        $AVSummary | Format-List
        Write-Output `n
        Write-Output ":::Scheduled Tasks Results:::"
        $SchTaskSummary | Format-Table
        if (($savelogs -eq "y") -or ($savelogs -eq "yes")) {
            Write-Output "Saving event logs to $logpath"
            Get-EventArchive | Out-Null
        } elseif (($savelogs -eq "n") -or ($savelogs -eq "no")) {
            Write-Output "Skipping logs"
        } else {
            Write-Output "Unknown response *$savelogs*, skipping logs"
        }
        
        Write-Output ("################################################################################################")
    ) *>&1 >> $maintlog
    Write-Output ("Maint Report saved to $maintlog")
}

Start-Maintenance -savelogs $savelogs


## addtional logs
## device manager
## patch status
## sys info
## DC Server Maint
## dcdiag
## pull users, last logon time
## ad / repl logs
## DS, DNS, FRS logs
## check for FRS being enabled still
## fsmo and domain/forest level
## warranty check - skip if virt.
## LT / SC installation status, last check in
## list of listening ports and processes associated with them.
## LT Integration 
## pull script from github (self updating)
## email html report to provided email list. SMTP Settings?
