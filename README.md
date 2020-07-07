# Server Maintenance Scripts

## Data gathering for server maintenance tasks

**NEW: Run as Automate Script, Report sent directly to Client Teams Maintenance Channel**

### **Run-ServMaint.ps1** - optional, for running outside of Automate
- Runs Server Maintenance against list of servers
    - *args:* 
        - listpath - location of servers.txt (default path: 'c:\ksmc\scripts')
        - DeployPSCore - Deploys PowerShellCore:latest before running maint
    - run as administrator
- Downloads updated copy of ServerMaint.ps1 from GitHub and copies to target machines, runs on each machine
- Copies Maintenance Reports back to server you run it on, creates master report

### **ServerMaint.ps1**
- Runs maintenance functions against each server
- Outputs report as .txt
- Exports Event Logs and Clears
- Current Supported Functions:
    - Get-HWInfo
        - Returns Phys/VM, Serial, Activation, Hardware Make/Model
    - Get-NetInfo
        - Returns Network Adapters- IPs, MAC Addr
    - Get-NetPortInfo
        - Returns Established, Listening, and Open ports
    - Get-EventArchive
        - Archives and Clears Event Logs from 'System', 'Application', and 'Security'
    - Get-FailedLogons
        - Checks current exported 'Security' Log for Failed Logons and returns Source Address, UserName, Time, and Failure Reason
    - Get-EvtLogsSummary
        - Checks current exported 'Application' and 'System' logs, returns log stats and summary
    - Get-SchTasks
        - Pulls scheduled tasks and returns status
    - Get-NTPConfig
        - Returns results of 'w32tm /query /status'
    - Get-Certs
        - Pulls certs from LocalMachine store and checks for any expiring in next 30 days
    - Get-SrvUptime
        - Returns uptime
    - Get-PSVersion
        - Pulls and returns PSVersion
    - Get-DiskInfo
        - Pulls disks, returns free space stats and frag status
    - Get-AV
        - Returns AV status depending on OS
        - Not supported on all Server OS older than 2016
        - Works best on Workstations
    - Get-Roles
        - Returns installed Server Roles, checks for specific roles and returns if installed (ADDS,DHCP,DNS,Print-Server,SMTP-Server)
    - Start-ADMaint
        - Pulls down latest copy of ADMaint.ps1 from GitHub and runs maint against PDCe
    - Start-Maintenance
        - Runs all functions and assembles report

### **ADMaint.ps1**

- Runs AD Maintenance info gathering
    - Get-ForestInfo
        - Returns Forest,Domains,FSMO Holders,Sites,GCs
    - Get-FRSState
        - Returns if sysvol is replicating using 'FRS' or 'DFSR'
    - Get-Users
        - Audits users for accounts that have:
            - Never logged-in
            - Not logged-in in over 30 days
            - Password is expired
            - Password set to never expire
            - Disabled Accounts
    - Get-Computers
        - Audits computers for accounts that have:
            - Never Logged-in
            - Not logged-in in over 30 days
            - Disabled Accounts
    - Get-ReplStatus
        - Returns results of:
            - repadmin /replsummary
            - repadmin /queue
            - repadmin /showrepl
    - Get-DCDiag
        - Returns results of 'dcdiag /q'
    - Start-ADMaint
        - Runs all functions and creates report


### **How To Run - Automate Script**
1. Navigate to Client Servers in Automate Control Center or Web Client. Select Server(s) to run against
2. Run Script under "Maintenance > Monthly Server Maintenance" 
3. Report will be emailed to email address of tech that initiated script, as well as Client's 'Maintenance' channel in Teams



### **How To Run - 'Run-ServMaint.ps1'** 
1. Download copy of "Run-ServMaint.ps1" to management machine -> put in "c:\ksmc\scripts"
2. Create "servers.txt" in "c:\ksmc\scripts" on management machine, list all hostnames in the file, one on each line
3. Run "Run-ServMaint.ps1" as admin
    - easiest method - open Powershell ISE as admin
    - browse and open script
4. Output will report when scripts finshes
    - Logs save to "c:\ksmc\scripts\maint\logs"
    - Reports save to "c:\ksmc\scripts\maint\reports"
5. "master-report-all" will be combination all reports from this run

