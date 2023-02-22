param([Parameter(Mandatory=$true)]$basepath)

#Checks if the session is being run as Admin (Some of the values won't populate without it)
#If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
#    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
#    Start-Process powershell -Verb runAs -ArgumentList $arguments
#    Break
#}

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

function Get-NetPortInfo{
    param ($computername = $env:COMPUTERNAME,[string]$PSVer)
    if ($PSVer -ge "5") {
        $established = (Get-NetTCPConnection -State Established | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State, @{name='Process';expression={(Get-Process -Id $_.OwningProcess).Name}}, CreationTime | Sort-Object Process | Format-Table -AutoSize)
        $listening = (Get-NetTCPConnection -State Listen | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State, @{name='Process';expression={(Get-Process -Id $_.OwningProcess).Name}}, CreationTime | Sort-Object Process | Format-Table -AutoSize)
        $openports = (Get-NetTCPConnection -State Listen | Select-Object LocalPort | Sort-Object -Property LocalPort -Unique | Format-Table -HideTableHeaders)
        [hashtable]$netportinfo = @{}
        $netportinfo.established = $established
        $netportinfo.listening = $listening
        $netportinfo.openports = $openports
    } else {
        $netportinfo = "Not Yet Supported (PSVer: $psver)"
    }
    return $netportinfo
}
#Archives the App, Sec, And Sys, event logs and clears the logs 
Function Get-EventArchive{            
    Param(
        $Computername = $ENV:COMPUTERNAME,
        [array]$EventLogs = @("application","security","system"),
        $BackupFolder
    )        
    Foreach ( $log in $EventLogs ) {
        If(!( Test-Path $BackupFolder )){ 
            New-Item $BackupFolder -Type Directory
        }
        $eventlog="$BackupFolder\$log" + "-" + (Get-Date -Format "MMddyyyy") + ".evt"
        (Get-CimInstance win32_nteventlogfile -ComputerName $computername | Where-Object {$_.logfilename -eq "$log"}) | Invoke-CimMethod -MethodName backupeventlog -Arguments @{ArchiveFileName=$eventlog}            
        [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog("$log")
        Start-Sleep -Seconds 30            
    }          
}

function Get-FailedLogons {
    param (
        $date = (Get-Date -format "MMddyyyy"),
        $loglocation = "",
        $secfile = "security-$date.evt"
    )
    function Get-FailureReason {
        Param($FailureReason)
          switch ($FailureReason) {
            '0xC0000064' {"Account does not exist"; break;}
            '0xC000006A' {"Incorrect password"; break;}
            '0xC000006D' {"Incorrect username or password"; break;}
            '0xC000006E' {"Account restriction"; break;}
            '0xC000006F' {"Invalid logon hours"; break;}
            '0xC000015B' {"Logon type not granted"; break;}
            '0xc0000070' {"Invalid Workstation"; break;}
            '0xC0000071' {"Password expired"; break;}
            '0xC0000072' {"Account disabled"; break;}
            '0xC0000133' {"Time difference at DC"; break;}
            '0xC0000193' {"Account expired"; break;}
            '0xC0000224' {"Password must change"; break;}
            '0xC0000234' {"Account locked out"; break;}
            '0x0' {"0x0"; break;}
            default {"Other"; break;}
        }
      }
    
    #check failed logins
    $seclogfile = "$loglocation\$secfile"

    $failedlogons = Get-WinEvent -Oldest -FilterHashTable @{path="$seclogfile";Logname="Security"; ID=4625} 
    $failedlogonstatus = @()

    foreach ($failedlogon in $failedlogons) {
        [hashtable]$fl = @{}
       
        $msgstring = $failedlogon.Message
        $sourceaddr = (($msgstring).Split("`n") | Select-String -Pattern "(?<SourceAddr>^\s+Source Network Address:\s+(.+))").ToString().Replace("`tSource Network Address:`t","").Trim()
        $acctnamearr = ($msgstring).Split("`n") | Select-String -Pattern "(?<AcctName>^\s+Account Name:\s+(.+))"
        $fail1 = (($msgstring).Split("`n") | Select-String -Pattern "(?<AcctName>^\s+Status:\s+(.+))").ToString().Replace("`tStatus:`t","").Trim()
        $fail2 = (($msgstring).Split("`n") | Select-String -Pattern "(?<AcctName>^\s+Sub Status:\s+(.+))").ToString().Replace("`tSub Status:`t","").Trim()
        $facctname1,$facctname2 = $acctnamearr
        $acct1 = ($facctname1.ToString()).Replace("`tAccount Name:`t`t","").Trim()
        $acct2 = ($facctname2.ToString()).Replace("`tAccount Name:`t`t","").Trim()
        if ($acctname -like "*-*") { $acctname = "LocalAcct: $acct1"} else { $acctname = $acct2}
        if ($sourceaddr -like "*-*") {$sourceaddr = "localhost"}

        $fl.SourceAddr = $sourceaddr
        $fl.AcctName = $acctname
        $fl.Time = $failedlogon.TimeCreated
        $fl.FailStatus = Get-FailureReason -failurereason $fail1
        $fl.FailSubStatus = Get-FailureReason -failurereason $fail2
        
        $FailedLogonStatus += New-Object -TypeName PSObject -Property $fl 

    } Return $FailedLogonStatus

}

function Get-EvtLogsSummary {
    param (
        $date=(Get-Date -format MMddyyyy),
        $loglocation = "",
        $appfile = "application-$date.evt",
        $sysfile = "system-$date.evt"
    )
    $applogfile = "$loglocation\$appfile"
    $syslogfile = "$loglocation\$sysfile"
    $evtlogsummary = @()
    [hashtable]$logs = @{}

    #$currenttotals = Get-WinEvent -listlog * | Select-Object logname,RecordCount | Where-Object {$_.recordcount } | Format-Table -autosize
    $applogs = Get-WinEvent -Oldest -FilterHashTable @{path="$applogfile";Logname="Application";Level=2,3}
    $syslogs = Get-WinEvent -Oldest -FilterHashTable @{path="$syslogfile";Logname="System";Level=2,3}

    $sysidcounts = $syslogs | Group-Object -Property ID -noelement | Sort-Object -Property Count -Descending    
    $logs.sysid = $sysidcounts | Where-Object {$_.Count -ge 10}
    $sids = ($logs.sysid | Select-Object *, @{ n="sidval"; e= { [int]($_.Name)}})
    $sid = $sids.sidval

    foreach ($id in $sid) {
        $slogs = $syslogs | Select-Object -Property LogName,LevelDisplayName,ProviderName,ID,TimeCreated,Message  | Where-Object {$_.ID -eq $id}
        $logs.sys += $slogs       
    }
    
    $appidcounts = $applogs | Group-Object -Property ID -noelement | Sort-Object -Property Count -Descending
    $logs.appid = $appidcounts | Where-Object {$_.Count -ge 10}
    $aids = ($logs.appid | Select-Object *, @{ n="appval"; e= { [int]($_.Name)}})
    $aid = $aids.appval

    foreach ($id in $aid) {
        $alogs = $applogs | Select-Object -Property LogName,LevelDisplayName,ProviderName,ID,TimeCreated,Message | Where-Object {$_.ID -eq $id}
        $logs.app += $alogs
    }

    ##### summary export like maint sheet - still need to figure out
    $appsumm = $logs.app | Group-Object -property ID | Sort-Object Count -Descending
    $logs.appsumm = $appsumm
    $syssumm = $logs.sys | Group-Object -property ID | Sort-Object Count -Descending
    $logs.syssumm = $syssumm
    

    $evtlogsummary += New-Object -TypeName PSObject -Property $logs
    
    Return $evtlogsummary
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
    $Volume = Get-WmiObject -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    $DiskFrag = $Volume.DefragAnalysis().DefragAnalysis
    $DiskInfo = Get-WmiObject -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Fragmentation";e={"{0:n2}" -f $DiskFrag.TotalPercentFragmentation}}
} elseif (($PSVer -lt "5") -and ($IsVirt -eq "True") ) {
    $Volume = Get-WmiObject -ComputerName $computerName Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $Null -ne $_.DriveLetter}  
    [hashtable]$DiskFrag = @{}
    $DiskFrag.TotalPercentFragmentation = "Virt-Skipping" 
    $DiskInfo = Get-WmiObject -ComputerName $computerName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}}, @{n="Fragmentation";e={"{0:n2}" -f $DiskFrag.TotalPercentFragmentation}}
}
return $DiskInfo
}

#Pull antivirus info from the registry
function Get-AV {
    [CmdletBinding()]
    param ([string]$ComputerName = $env:COMPUTERNAME,[string]$PSVer)  
    if ($PSVer -ge "5") {
        [string]$OSVersion = (Get-CimInstance win32_operatingsystem -computername $Computername).Caption
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
            $AVProduct = if ((Test-Path -Path 'C:\Program Files\*' -Include ('*Sophos*')) -eq "True") { "Sophos" } elseif ((Test-Path -Path 'C:\Program Files\*' -Include ('*Trend*')) -eq "True") { "Trend" } elseif ((Test-Path -Path 'C:\Program Files\*' -Include ('*Symantec*')) -eq "True") { "Symantec" } elseif ((Test-Path -Path 'C:\Program Files\*' -Include ('*Bitdefender*')) -eq "True") { "Bitdefender" } else {"Windows Defender or Unknown Product"}
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
        [string]$OSVersion = (Get-WmiObject win32_operatingsystem -computername $Computername).Caption
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

#Get Installed Server Roles
function Get-Roles{
    $roles = (Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Installed' })
    if ($roles | Where-Object {$_.name -eq 'AD-Domain-Services'}) { $adrole = "Installed" } else { $adrole = "Not Installed" }
    if ($roles | Where-Object {$_.name -eq 'DHCP'}) { $dhcprole = "Installed" } else { $dhcprole = "Not Installed" }
    if ($roles | Where-Object {$_.name -eq 'DNS'}) { $dnsrole = "Installed" } else { $dnsrole = "Not Installed" }
    if ($roles | Where-Object {$_.name -eq 'Print-Server'}) { $printrole = "Installed" } else { $printrole = "Not Installed" }
    if ($roles | Where-Object {$_.name -eq 'SMTP-Server'}) { $smtprole = "Installed" } else { $smtprole = "Not Installed" }


    [hashtable]$serverroles = @{} 
    $serverroles.ad = $adrole
    $serverroles.dhcp = $dhcprole
    $serverroles.dns = $dnsrole
    $serverroles.print = $printrole
    $serverroles.smtp = $smtprole
    $serverroles.roles = $roles.Name
    Return $serverroles
}

function Start-ADMaint {
    param([Parameter(Mandatory=$true)]$basepath)
    $scriptpath = "$basepath\ADMaint.ps1"
    $scripturl = "https://raw.githubusercontent.com/KSMC-TS/server-maintenance-scripts/main/ADMaint.ps1"
      
    if ((Test-Path $scriptpath) -eq $True) { Remove-Item $scriptpath -force }
    Invoke-WebRequest $scripturl -OutFile $scriptpath
    $pwsh = Test-Path "$env:ProgramFiles\PowerShell\*"  
    if ($pwsh -eq $true) {
        Write-Output "Running in Powershell Core (6.0+)"
        $remoteCommand = { 
            pwsh.exe -command "& $basepath\ADMaint.ps1 -basepath $basepath"
        }
    } else {
        Write-Output "Running in Powershell (up to 5.1)"
        $remoteCommand = { 
            powershell.exe -command "& $basepath\ADMaint.ps1 -basepath $basepath"
        }
    }
    Write-Verbose "Running AD Maintenance"
    Invoke-Command -ScriptBlock $remoteCommand
    $admaint = "AD Maintenance is Complete"
    Return $admaint
}

#Data Gathering and Report Building
function Start-Maintenance{
    [Cmdletbinding()]
    param($basepath)
    $date = Get-Date
    $datef = Get-Date -Format "MMddyyyy"
    $maintpath = "$basepath\maint"
    $logpath = "$maintpath\logs"
    $maintfile = "maint_report-$env:COMPUTERNAME-"+(Get-Date -Format "MMddyyyy")+".log"
    $maintallfile = "maint_all-$env:COMPUTERNAME-"+(Get-Date -Format "MMddyyyy")+".log"
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
        $DiskSummary = Get-DiskInfo -PSVer $PSMaj
        $NetPortInfo = Get-NetPortInfo -PSVer $PSMaj
        $netopenports = $netportinfo.openports
        $netlistening = $netportinfo.listening
        $netestablished = $netportinfo.established
        $DiskSummary = Get-DiskInfo -PSVer $PSMaj -IsVirt $HWVM
        $DiskSummary = Get-DiskInfo -PSVer $PSMaj -IsVirt $HWVM
        $AVSummary = Get-AV -PSVer $PSMaj
        $CertSummary = Get-Certs
        $NTPSummary = Get-NTPConfig
        $SchTaskSummary = Get-SchTasks -PSVer $PSMaj
        $lastboot = Get-SrvUptime -PSVer $PSMaj
        $failedlogons = Get-FailedLogons -loglocation $logpath
        $evtlogsummary = Get-EvtLogsSummary -loglocation $logpath
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
        if ($os -like "*Server*") { 
            $roles = Get-Roles
            if ($roles.ad -eq "Installed") {
                Write-Output "ADDS Installed, checking for PDCe"
                $domainFQDN = "$env:USERDNSDOMAIN"
                $context = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext("Domain",$domainFQDN)
                $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($context)
                $pdce = $domain.pdcRoleOwner
                if ($pdce -like "$env:ComputerName.$domainFQDN") {
                    Write-Output "Server is PDCe, Running AD Maintenance"
                    Start-ADMaint -basepath $basepath
                }
            }
        } else { 
            $roles = @{}
            $roles.roles = "not server OS, skipping roles"
        }
        Write-Output ":::Server Roles:::"
        $roles.roles
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
        Write-Output ":::Network - Adapters:::"
        $NetInfo | Format-Table
        Write-Output ":::Network - Listening Ports:::"
        $netlistening
        Write-Output ":::Network - Established Ports:::"
        $netestablished
        Write-Output ":::Network - Open Port List:::"
        $netopenports
        Write-Output ":::Disk Info:::"
        $DiskSummary | Format-Table
        Write-Output ":::Anti-Virus Summary:::"
        $AVSummary | Format-List
        Write-Output `n
        Write-Output ":::Scheduled Tasks Results:::"
        $SchTaskSummary | Format-Table
        Write-Output "Saving event logs to $logpath, sleeping for 30s"
        Get-EventArchive -backupfolder $logpath
        Start-Sleep -Seconds 30
        Write-Output `n
        Write-Output ":::Failed Logons Summary:::"
        $failedlogons | Select-Object -First 50 | Format-Table
        Write-Output `n
        Write-Output ":::System - Event Log Summary"
        $evtlogsummary.syssumm | Format-Table
        Write-Output ":::Application - Event Log Summary"
        $evtlogsummary.appsumm | Format-Table
        
        
        Write-Output ("################################################################################################")
    ) *>&1 >> $maintlog
    Write-Output ("Maint Report saved to $maintlog") 
    

    Get-Content "$maintpath\maint_report*$datef.log" | Set-Content $maintpath\$maintallfile


}

Start-Maintenance -basepath $basepath


## addtional logs
## device manager
## patch status
## sys info - ?
## warranty check - skip if virt.
## LT / SC installation status, last check-in
## LT Integration 
## check for services running as "service accounts"
