param ()

function Get-ForsetInfo {
    $Forest = [system.directoryservices.activedirectory.Forest]::GetCurrentForest() 
    "Forest Name:                " + $Forest.Name 
    "  Forest Functional Level:  " + $Forest.ForestMode 
    "  Schema Master:            " + $Forest.SchemaRoleOwner 
    "  Domain Naming Master:     " + $Forest.NamingRoleOwner 
 
    # Determine Configuration naming context from RootDSE object. 
    $RootDSE = [System.DirectoryServices.DirectoryEntry]([ADSI]"LDAP://RootDSE") 
    $ConfigNC = $RootDSE.Get("configurationNamingContext") 
 
    # Use ADSI Searcher object to determine NetBIOS names of domains. 
    $Searcher = New-Object System.DirectoryServices.DirectorySearcher 
    $Searcher.SearchScope = "subtree" 
    $Searcher.PropertiesToLoad.Add("nETBIOSName") > $Null 
    # Base of search is Partitions container in the configuration container. 
    $Searcher.SearchRoot = "LDAP://cn=Partitions,$ConfigNC" 
 
    ForEach ($Domain In $Forest.Domains) 
    { 
        # Convert DNS name into distinguished name. 
        $DN = "dc=" + $Domain.Name.Replace(".", ",dc=") 
        # Find the corresponding partition and retrieve the NetBIOS name. 
        $Searcher.Filter = "(nCName=$DN)" 
        $NetBIOSName = ($Searcher.FindOne()).Properties.Item("nETBIOSName") 
        "`nDomain Name:                " + $Domain.Name 
        "  Distinguished Name:       $DN" 
        "  NetBIOS Name:             $NetBIOSName" 
        "  Domain Functional Level:  " + $Domain.DomainMode 
        "  PDC Emulator:             " + $Domain.PdcRoleOwner 
        "  RID Master:               " + $Domain.RidRoleOwner 
        "  Infrastructure Master:    " + $Domain.InfrastructureRoleOwner 
        "  Domain Controllers:" 
 
        ForEach ($DC In $Domain.DomainControllers) 
        { 
            "                            " + $DC.Name 
        } 
    } 
 
    "Sites:" 
    ForEach ($Site In $Forest.Sites) 
    { 
        "                            " + $Site.Name 
    } 
 
    "Global Catalogs:" 
    ForEach ($GC In $Forest.GlobalCatalogs) 
    { 
        "                            " + $GC.Name 
    }

}


function Get-FRSState {
    $frsstate = dfsrmig /getmigrationstate
    if ($frsstate -like "*Eliminated*") { 
        $dfsrstate = "Sysvol is using DFSR"
    } elseif ($frsstate -like "*Prepared*") { 
        $dfsrstate = "Sysvol is using FRS *** (DFSR Mig Status - Prepared)"
    } elseif ($frsstate -like "*Redirected*") { 
        $dfsrstate = "Sysvol is using FRS *** (DFSR Mig Status - Redirected)"
    } else { 
        $dfsrstate = "Sysvol is using FRS ***" 
    }
    Return $dfsrstate
}


function Get-Users {
    $useraudit = @{}
    $useraudit.NeverLogon = Get-ADUser -Filter {(-not(LastLogonDate -like "*")) -and (Enabled -eq $true)} -Properties SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword | Select-Object SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword
    $useraudit.LogonMinus3Mo = Get-ADUser -Filter {(Enabled -eq $true) -and (LastLogondate -lt $date)} -Properties SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword | Select-Object SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword
    $useraudit.passwordexpired = Get-ADUser -Filter {(Enabled -eq $true) -and (PasswordExpired -eq $true)} -Properties SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword | Select-Object SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword
    $useraudit.Passneverexpire = Get-ADUser -Filter {(Enabled -eq $true) -and (PasswordNeverExpires -eq $true)} -Properties SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword | Select-Object SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword
    $useraudit.disabled = Get-ADUser -Filter {(Enabled -eq $false)} -Properties SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword | Select-Object SamAccountName,LastLogonDate,PasswordExpired,PasswordLastSet,PasswordNeverExpires,CannotChangePassword
    Return $useraudit
}

function Get-Computers {
    $compaudit = @{}
    $compaudit.NeverLogon = Get-ADComputer -Filter {(-not(LastLogonDate -like "*")) -and (Enabled -eq $true)} -Properties Name,LastLogonDate | Select-Object Name,LastLogonDate | Sort-Object LastLogonDate
    $compaudit.LogonMinus3Mo = Get-ADComputer -Filter {(Enabled -eq $true) -and (LastLogonDate -lt $date)} -Properties Name,LastLogonDate | Select-Object Name,LastLogonDate | Sort-Object LastLogonDate
    $compaudit.disabled = Get-ADComputer -Filter {(Enabled -eq $false)} -Properties Name,LastLogonDate | Select-Object Name,LastLogonDate | Sort-Object LastLogonDate
    Return $compaudit
}

function Get-ReplStatus {
    $repstatus = @{}
    $repstatus.repsum = repadmin /replsummary
    $repstatus.queue = repadmin /queue
    $repstatus.showrepl = repadmin /showrepl
    Return $repstatus

}

function Get-DCdiag {
    $dcdiag = dcdiag /q
    Return $dcdiag
}


function Start-ADMaint{
    [Cmdletbinding()]
    param([string]$Computername)
    Import-Module Activedirectory
    $date = Get-Date
    $maintpath = "c:\ksmc\scripts\maint"
    $logpath = "$maintpath\logs"
    $maintfile = "AD-maintenance_report-$env:USERDOMAIN-"+(Get-Date -Format "MMddyyyy")+".log"
    $maintlog = "$maintpath\$maintfile"
    $pathexists = Test-Path $logpath
    if ($pathexists -eq $True) { 
        Write-Verbose "($logpath) already exists" -Verbose 
    } else { 
        New-Item -ItemType Directory -Path $logpath -Force
        Write-Verbose "($logpath) was created" -Verbose 
    } 
  
    $(
        $forestinfo = Get-ForestInfo
        $frsstate = Get-FRSState
        $useraudit = Get-Users
        $compaudit = Get-Computers
        $replstatus = Get-ReplStatus
        $dcdiag = Get-DCDiag

        Write-Output "******AD Maintenance Report******"
        Write-Output "Current Date: $date"
        Write-Output "*** Forest / Domains info ***"
        $forestinfo
        Write-Output "*** Replication Status ***"
        $repstatus.repsum
        Write-Output "*** FRS Status ***"
        $frsstate
        Write-Output "*** User Audit ***"
        $useraudit
        Write-Output "*** Computer Audit ***"
        $compaudit
        Write-Output "*** DCDiag ***"
        $dcdiag

        
        
        Write-Output ("################################################################################################")
    ) *>&1 >> $maintlog
    Write-Output ("Maint Report saved to $maintlog") 
    
}

Start-ADMaint



## ad / repl logs
## DS, DNS, FRS logs
## dns FSMO holders
