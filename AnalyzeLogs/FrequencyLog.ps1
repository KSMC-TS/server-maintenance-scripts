<#
.Synopsis
   Go to application, system, and security (optional) events logs in the current machine and get all the events information and order it from most frequent to less in a nice AMSChars graphics.
.DESCRIPTION
   Get a Histogram in HTML based on 2 or 3 JSON files (depends if it's security log involved or not), then compiled in a js file called "graph.js" and use it to deploy a beautiful Histogram from the most fre�cuent to the less frequent in a single HTML file for all the logs involved
   
.EXAMPLE  
	FrequencyLog.ps1   
	Get the graphics for the most frequent event to the less in an amazing AMSChars graphic. (System and application).
.EXAMPLE	
	FrequencyLog.ps1 -IncludeSecurity
	Get the graphics for the most frequent event to the less in an amazing AMSChars graphic (System, Security, and application).
.EXAMPLE	
	FrequencyLog.ps1 -MinimunRepetitions 10 -IncludeSecurity   
	Get the graphics for the most frequent event (security, system, application) to the less and have been occurring more than 10 times during the whole information in the logs.
.EXAMPLE	
	FrequencyLog.ps1 -Days 7 -IncludeSecurity   
	Get the graphics for events from all frequency logs in the last 7 days.
.EXAMPLE	
	FrequencyLog.ps1 -MinimunRepetitions 10 -Days 30   
	Get the graphics for events in the logs (System, Application), from the last 30 days (last month) that have been repeating 10 or more times
.EXAMPLE	
	FrequencyLog.ps1 -MinimunRepetitions 20 -Days 7 -IncludeSecurity   
	Get the graphics for events in the logs (System, Security, Application), from the last 7 days that have been repeating 20 or more times
.EXAMPLE	
	FrequencyLog.ps1 -MinimunRepetitions 100 -Days 100 -IncludeSecurity -computerp ServerA   
	Get the graphics for events in the logs (System, Security, Application), from the last 100 days that have been repeating 100 or more times in the computer ServerA

.INPUTS
	OPTIONAL Parameters:
	[string]$computerp -- Computer where you want to run the script, the default value is "localhost".
	[int]$MinimunRepetitions=1  => minimum repetitions to be considered in the graph
	[int]$Days=0 => default value 0, means search in the whole information, if you modify this number it will search that number of days behind from today.
	[switch]$IncludeSecurity  => It's the way you can select if you want to include the security events (usually takes more time than normal).

.OUTPUTS
   1 JSON file for each log and then the compilation in graph.js.
   Also, it's added a graphYYYYMMDD.html file; this is the one to click on when the script is done with his job.
.NOTES
	#version 5.07
	Updated the bug on the "Last Time Written" of the events not showing correctly

	#Version 4.0
	Added Get-Help compatibility so that you can use .\Frequencylog.ps1
	Requires Powershell 3.0 instead of 4 or 5. (it uses Convertfrom-JSON and Convertto-JSON) Cmdlets (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-5.1)
	Security events will now be optional, so you can get the graphics from application and system faster because security logs always take more time. You can still add the security by using the switch parameter  -IncludeSecurity
	Added parameter  Minimunrepetitions to be in the graphics.    
	Added days parameter, so you can actually set this parameter to look a specific number of days in the past.    
	Improved error messages.
	Updated to amcharts_3.21.7.free. (Nov 07,2017)

   # Version 3.0
	Updated to work win PowerShell 4.0 (so requires changes from 5 to 4) (windows 7/8/8.1/10 and Windows server 2008 R2/2012/2012R2/2016
	Removed all Write-progress calls
	added validation to functions
	added check version
	Added log file 
	Corrected bugs in version 2.0 in date
	Added Clean up section

	# Version 2.0 (Tested on windows 8.1/10 pro and Win 7 SP1 Ultimate)
	# Reduced Minimum repetitions from 5 to 2
	Reduced Minimun repetitions var on line 25 from 5 to 2 (you can move it to 1).
	Corrected the minimun repetitions variables relation instead of "greather than" to be "greather equal to"
	Corrected name of the Html file from Graphics.htm to "Graphics-YYYYMMdd.html"
	Either way remember that the data will be refreshed every time you run the script.
	
	Added Security events into the graphics
	Requires Powershell Version 5
	#version 3.0

	Jose Gabriel Ortega (j0rt3g4@j0rt3g4.com / https://www.j0rt3g4.com)
	CEO J0rt3g4 Consulting Services
.COMPONENT
   This cmdlet doesn't belongs to any component
.ROLE
   The role of this script is already described in the synopsis and descriptions fields.
.FUNCTIONALITY
   Get an Hystogram in HTML based on 2 or 3 json files (depends if it's security log involved or not), then compiled in a js file called "graph.js" and use it to deploy a beautiful Hystogram from the most fre�cuent to the less frequent in a single html file for all the logs involved
#>

#requires -version 3
[Cmdletbinding()]
param(
	[Parameter(mandatory=$false,position=0)][alias("computer")][string]$computerp,
	[Parameter(mandatory=$false,position=1)][alias("Atleast","Repetitions")][int]$MinimunRepetitions=1,
	[Parameter(mandatory=$false,position=2)][int]$Days=0,
	[Parameter(mandatory=$false,position=3)][Alias("security")][switch]$IncludeSecurity
)
#Variables
#CleanUpVariables
$CleanUpGlobal=@()
$cleanUpLocal=@()

#Globals:
$TimeStart=Get-Date
$global:ScriptLocation = "C:\ksmc\scripts\maint\AnalyzeLogs"

#$global:ScriptLocation = "D:\Librerias\MyDocs\Visual Studio 2015\Projects\Changed it\Changed it\Frequency" #for local test
$global:DefaultLog = "$global:ScriptLocation\$computerp-scriptlog.log"


#Color using Chaotic Random Color shceme 
$global:R=4.0
$global:Ite=3000
$global:trans=1000

#Locals variables: Files and date
$today = Get-Date -Format "yyyyMMdd"
$html           ="$global:ScriptLocation\$computerp-eventsreport-$today.htm"
$jsonsystem     ="$global:ScriptLocation\$computerp-system-$today.json"
$jsonapplication="$global:ScriptLocation\$computerp-application-$today.json"
$jsonsecurity   ="$global:ScriptLocation\$computerp-security-$today.json"


#cleanup Variables
$CleanUpGlobal+="ScriptLocation"
$CleanUpGlobal+="R"
$CleanUpGlobal+="Ite"
$CleanUpGlobal+="trans"
$cleanUpLocal+="today"
$cleanUpLocal+="html"
$cleanUpLocal+="jsonsystem"
$cleanUpLocal+="jsonapplication"
$cleanUpLocal+="jsonsecurity"

#region functions            ## 
########  FUNCTIONS  ##########
##                           ##
function Write-Log{
	[CmdletBinding()]
	#[Alias('wl')]
	[OutputType([int])]
	Param(
			# The string to be written to the log.
			[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)] [ValidateNotNullOrEmpty()] [Alias("LogContent")] [string]$Message,
			# The path to the log file.
			[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=1)] [Alias('LogPath')] [string]$Path=$global:DefaultLog,
			[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=2)] [ValidateSet("Error","Warn","Info","Load","Execute")] [string]$Level="Info",
			[Parameter(Mandatory=$false)] [switch]$NoClobber,
			[Parameter(Mandatory=$false)] [switch]$Hide
	)

	Process{
		
		if ((Test-Path $Path) -AND $NoClobber) {
			Write-Warning "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
			Return
			}

		# If attempting to write to a log file in a folder/path that doesn't exist
		# to create the file include path.
		elseif (!(Test-Path $Path)) {
			Write-Verbose "Creating $Path."
			$NewLogFile = New-Item $Path -Force -ItemType File
			}

		else {
			# Nothing to see here yet.
			}

		# Now do the logging and additional output based on $Level
		switch ($Level) {
			'Error' {
				if($hide){
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") ERROR: `t $Message" | Out-File -FilePath $Path -Append
				}
				else{
					Write-Host $Message -ForegroundColor Red
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") ERROR: `t $Message" | Out-File -FilePath $Path -Append
				}
				break;
				}
			'Warn' {
				if($hide){
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") WARNING: `t $Message" | Out-File -FilePath $Path -Append
				}
				else{
					Write-Warning $Message
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") WARNING: `t $Message" | Out-File -FilePath $Path -Append
				}
				break;
				}
			'Info' {
				if($hide){
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") INFO: `t $Message" | Out-File -FilePath $Path -Append
				}
				else{
					Write-Host $Message -ForegroundColor Green
					Write-Verbose $Message
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") INFO: `t $Message" | Out-File -FilePath $Path -Append
				}
				break;
				}
			'Load' {
				if($hide){
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") LOAD: `t $Message" | Out-File -FilePath $Path -Append
				}
				else{
					Write-Host $Message -ForegroundColor Magenta
					Write-Verbose $Message
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") LOAD: `t $Message" | Out-File -FilePath $Path -Append
				}
				break;
				}
			'Execute' {
				if($hide){
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") EXEC: `t $Message" | Out-File -FilePath $Path -Append
				}
				else{
					Write-Host $Message -ForegroundColor Cyan
					Write-Verbose $Message
					Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") EXEC: `t $Message" | Out-File -FilePath $Path -Append
				}
				break;
				}
			}
	}
}
function GetPSVersion{
	[cmdletbinding()]
	param()
	PROCESS{
	  $version=$PSVersionTable.PSVersion
		$major = $version.Major
		$minor = $version.Minor
		write-log -level Info -message "You are running powershell version ""$major.$minor"""
	}
	END{
		return $major
	}
}
function CheckExists{
	[Cmdletbinding()]
	param(
		[Parameter(mandatory=$true,position=0)][ValidateNotNull()]$itemtocheck,
		[Parameter(mandatory=$true,position=1)][ValidateNotNull()]$colection
	)
	BEGIN{
		$item=$null
		$exist=$false
	}
	PROCESS{
		foreach($item in $colection){
			if($item.EventID -eq $itemtocheck){
				$exist=$true
				break;
			}
		}
	}
	END{
		return $exist
	}
}
function CheckCount{
	[Cmdletbinding()]
	param(
		[Parameter(mandatory=$true,position=0)][ValidateNotNull()]$itemtocheck,
		[Parameter(mandatory=$true,position=1)][ValidateNotNull()]$colection
	)
	BEGIN{
		$item=$null
		$count=0
	}
	PROCESS{
		foreach($item in $colection){
			
			if($item.EventID -eq $itemtocheck){
				$count++
			}
		}
	}
	END{
		return $count
	}
}
function LastWrittenTime{
	[Cmdletbinding()]
	param(
		[Parameter(mandatory=$true,position=0)][ValidateNotNull()]$colection,
		[Parameter(mandatory=$true,position=1)][ValidateNotNull()]$EventID
	)
	BEGIN{
		$filterCollection= $colection | Where-Object{ $_.EventID -eq $EventID} | Sort-Object TimeWritten -Descending
	} 
	PROCESS{
		$last = $filterCollection | select -First 1 -ExpandProperty TimeWritten
		$first = $filterCollection | select -Last 1  -ExpandProperty TimeWritten

		<#
		$previous = $filterCollection | select TimeWritten -First 1
		
		$last = $filterCollection | select TimeWritten -First 1
		foreach($item in $filterCollection){
			if($item.TimeWritten -lt $previous.TimeWritten){
				$previous =$item.TimeWritten
			}
			if($item.TimeWritten -gt $last.TimeWritten){
				$last = $item.TimeWritten
			}
		}#>
	}
	END{
		$output = New-Object psobject -Property @{
			first= $first
			last= $last
		}
		return $output
	}
}
function CreateJS{
	[Cmdletbinding(DefaultParameterSetName="All")]
	param(
		[Parameter(mandatory=$true,position=0)][ValidateNotNull()]$SystemData,
		[Parameter(mandatory=$true,position=1)][ValidateNotNull()]$AppData,
		[Parameter(mandatory=$false,position=3,ParameterSetName="sec")]$SecData, #optional to the Sec parameter sec
		[Parameter(mandatory=$false,position=2)]$JSFile="$global:ScriptLocation\graph.js" #optional common to all parameters set.
	)
	$JSContent+='
	var chart;
	var SystemData ='
	$JSContent+=$SystemData
	$JSContent+=';
	var appData ='
	$JSContent+=$AppData
	$JSContent+=';'
	
	if($SecData){
		$JSContent+='var secData ='
		$JSContent+=$SecData
	}

	$JSContent+=';
		AmCharts.ready(function () {
		var chart = AmCharts.makeChart("chartdiv",{
			"type": "serial",
			"dataProvider": SystemData,
			"categoryField": "EventID",
			"startDuration": 1,
			//axes
			"valueAxes": [ {
				"dashLength": 5,
				"title": "Frecuency of the event",
				"axisAlpha": 0,
			}],
			"gridAboveGraphs": false,
			
			"graphs": [ {
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=' + "Yellow" +'>[[EntryType]]</b>",
				"fillAlphas": 0.8,
				"lineAlpha": 0.2,
				"type": "column",
				"valueField": "Count",
				"colorField": "color"
			}],
			"chartCursor": {
				"categoryBalloonEnabled": false,
				"cursorAlpha": 0,
				"zoomable": false
			},
			
			"categoryAxis": {
				"gridPosition": "start",
				"gridAlpha": 0,
				"fillAlpha": 1,
				"labelRotation" : 60,
				"fillColor": "#EEEEEE",
				"gridPosition": "start"
			},
			"creditsPosition" : "top-right",
			"export": {
				"enabled": true
			}
	});

		var chart2 = AmCharts.makeChart("chart2div",{
			"type": "serial",
			"dataProvider":appData,
			"categoryField": "EventID",
			"startDuration": 1,
			//axes
			"valueAxes": [ {
				"dashLength": 5,
				"title": "Frecuency of the event",
				"axisAlpha": 0,
			}],
			"gridAboveGraphs": false,
			
			"graphs": [ {
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=' + "Yellow" +'>[[EntryType]]</b>",
				"fillAlphas": 0.8,
				"lineAlpha": 0.2,
				"type": "column",
				"valueField": "Count",
				"colorField": "color"
			}],
			"chartCursor": {
				"categoryBalloonEnabled": false,
				"cursorAlpha": 0,
				"zoomable": false
			},
			
			"categoryAxis": {
				"gridPosition": "start",
				"gridAlpha": 0,
				"fillAlpha": 1,
				"labelRotation" : 60,
				"fillColor": "#EEEEEE",
				"gridPosition": "start"
			},
			"creditsPosition" : "top-right",
			"export": {
				"enabled": true
			}
	});
	'
	if($SecData){
	$JSContent+='
		var chart3 = AmCharts.makeChart("chart3div",{
			"type": "serial",
			"dataProvider":secData,
			"categoryField": "EventID",
			"startDuration": 1,
			//axes
			"valueAxes": [ {
				"dashLength": 5,
				"title": "Frecuency of the event",
				"axisAlpha": 0,
			}],
			"gridAboveGraphs": false,
			
			"graphs": [ {
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=' + "Yellow" +'>[[EntryType]]</b>",
				"fillAlphas": 0.8,
				"lineAlpha": 0.2,
				"type": "column",
				"valueField": "Count",
				"colorField": "color"
			}],
			"chartCursor": {
				"categoryBalloonEnabled": false,
				"cursorAlpha": 0,
				"zoomable": false
			},
			
			"categoryAxis": {
				"gridPosition": "start",
				"gridAlpha": 0,
				"fillAlpha": 1,
				"labelRotation" : 60,
				"fillColor": "#EEEEEE",
				"gridPosition": "start"
			},
			"creditsPosition" : "top-right",
			"export": {
				"enabled": true
			}
	});
'
	} #endif

$JSContent+='
			//Original
		/*
		// SERIAL CHART
		chart = new AmCharts.AmSerialChart();
		chart.dataProvider = SystemData;
		chart.categoryField = "EventID";
		chart.startDuration = 1;


		// AXES
		// category
		var categoryAxis = chart.categoryAxis;
		categoryAxis.labelRotation = 60; // this line makes category values to be rotated
		categoryAxis.gridAlpha = 0;
		categoryAxis.fillAlpha = 1;
		categoryAxis.fillColor = "#EEEEEE";
		categoryAxis.gridPosition = "start";

		// value
		var valueAxis = new AmCharts.ValueAxis();
		valueAxis.dashLength = 5;
		valueAxis.title = "Frecuency of the event";
		valueAxis.axisAlpha = 0;
		chart.addValueAxis(valueAxis);

		// GRAPH
		var graph = new AmCharts.AmGraph();
		graph.valueField = "Count";
		graph.colorField = "color";
		graph.balloonText = "<b>[[category]]: [[value]]</b>";
		graph.type = "column";
		graph.lineAlpha = 0;
		graph.fillAlphas = 1;
		
		chart.addGraph(graph);

		// CURSOR
		var chartCursor = new AmCharts.ChartCursor();
		chartCursor.cursorAlpha = 0;
		chartCursor.zoomable = false;
		chartCursor.categoryBalloonEnabled = false;
		chart.addChartCursor(chartCursor);

		chart.creditsPosition = "top-right";

		// WRITE
		chart.write("chartdiv");
		*/
});'

	$JSContent | Out-File $JSFile -Encoding utf8
}

function CreateHtml{
	param(
		[Parameter(mandatory=$true,position=0)][ValidateNotNull()][string]$filename,
		[Parameter(mandatory=$false,position=3,ParameterSetName="sec")][switch]$IncludeSecurity #optional to the Sec parameter sec
	)
	BEGIN{}
	PROCESS{
	$htmlFile=$null
	$htmlFile+='<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title>Frecuency on Events</title>
	<link rel="stylesheet" href="style.css" type="text/css">
	<script src="amcharts.js" type="text/javascript"></script>
	<script src="serial.js" type="text/javascript"></script>
	<!-- scripts for exporting chart as an image -->
		<!-- Exporting to image works on all modern browsers except IE9 (IE10 works fine) -->
		<!-- Note, the exporting will work only if you view the file from web server -->
		<!--[if (!IE) | (gte IE 10)]> -->
		<script type="text/javascript" src="plugins/export/export.min.js"></script>
		<link  type="text/css" href="plugins/export/export.css" rel="stylesheet">
		<!-- <![endif]-->
	<script type="text/javascript" src="graph.js"></script> <!-- This file is created by a function in the script -->
</head>
<body>
	<center>
		<h2>Frecuency of events in Event Viewer: System</h2>
	</center>
	<div id="chartdiv" style="width: 100%; height: 415px;"></div>
	<div>&nbsp;</div>
	<center>
		<h2>Frecuency of events in Event Viewer: Application</h2>
	</center>
	<div id="chart2div" style="width: 100%; height: 415px;"></div>
	<div>&nbsp;</div>'

	if($IncludeSecurity){
	$htmlFile+='
	<center>
		<h2>Frecuency of events in Event Viewer: Security</h2>
	</center>
		<div id="chart3div" style="width: 100%; height: 415px;"></div>'
	}
	$htmlFile+='
	</body>
	</html>'
	}
	END{
		$htmlFile | Out-File $filename -Encoding utf8
	}
}
function Get-CaoticRandoms{
	param(
		[Parameter(Mandatory=$true,Position=0)][Int32]$numb,
		[Parameter(Mandatory=$false,Position=1)][Double]$Max = 16777215.0 #Result of changing FFFFFF hex to decimal demo: $value="0xffffff"; [convert]::ToInt32($value,16)
	)
	BEGIN{
		#Logistic Map Random Number Generator
		[int]$i=0;
		[Array]$output =@()
	}
	PROCESS{
		[double]$x1=0.0
		
		#[long]$time = Get-Date -uformat %V%j #https://technet.microsoft.com/en-us/library/ee692801.aspx (Get Week of the year and hour of the day)
		#$Rdn.setSeed($time)
		#LogisticMap
		[Random]$Rdn = New-Object System.Random
		
		$x0 = $Rdn.NextDouble()

		$total = $global:Ite + $global:trans
		for($c=0 ; $c -lt $total ; $c++){
			$x1 = $global:R * $x0 * (1.0 - $x0)
			$x0=$x1
			if( ($c -gt $global:trans) -and ($c -gt ($total - $numb+1) ) ){
				$output+=[convert]::ToInt32([Math]::Floor([decimal]$x1*$Max),10)
			}

		}
	}
	END{
		return $output
	}
}
function NewAssignColor{
	param(
		[Parameter(Mandatory=$true,Position=0)]$number
	)
	BEGIN{}
	PROCESS{
		#convert to hex 6 chars
		$hex = $number.ToString("x6")
	}
	END{
		return $hex
	}
}
function RdnNumber{
	BEGIN{
		#Logistic Map Random Number Generator
		[int]$i=0;
	}
	PROCESS{
		Start-Sleep -m 100
		
		[double]$x1=0.0

		#LogisticMap
		[Random]$Rdn = New-Object System.Random
		$x0 = $Rdn.NextDouble()

		$total = $global:Ite + $global:trans
		for($c=0 ; $c -lt $total ; $c++){
			$x1 = $global:R * $x0 * (1.0 - $x0)
			$x0=$x1
		}
	}
	END{
		return [convert]::ToInt32([Math]::Floor([decimal]($x1*21.0)),10)
	}
}
function AssignColor{
	BEGIN{
		[int]$i = RdnNumber
		[string]$out=$null
	}
	PROCESS{
		switch($i){
			0 {
				$out="#AE3B3B"
				break;
			}
			1 {
				$out="#FFABAB"
				break;
			}
			2 {
				$out="#D86D6D"
				break;
			}
			3{
				$out="#851818"
				break;
			}
			4{
				$out="#5A0101"
				break;
			}
			5{
				$out="#AE743B"
				break;
			}
			6{
				$out="#FFD5AB"
				break;
			}
			7{
				$out="#D8A26D"
				break;
			}
			8{
				$out="#854E18"
				break;
			}
			9{
				$out="#5A2D01"
				break;
			}
			10{
				$out="#275E6C"
				break;
			}
			11{
				$out="#6E98A1"
				break;
			}
			12{
				$out="#457986"
				break;
			}
			13{
				$out="#114652"
				break;
			}
			14{
				$out="#022E38"
				break;
			}
			15{
				$out="#2F8B2F"
				break;
			}
			16{
				$out="#8ACE8A"
				break;
			}
			17{
				$out="#57AD57"
				break;
			}
			18{
				$out="#136B13"
				break;
			}
			19{
				$out="#014801"
				break;
			}
			default {
				$out="#275F6C"
				break;
			}
		}
	}
	END{
		return $out
	}
}
function FrequencyData{
	param(
		[Parameter(mandatory=$true,position=0)][ValidateSet("System","Application","security")][string]$log,
		[Parameter(mandatory=$true,position=1)]$minimun,
		[Parameter(mandatory=$false,position=2)]$days,

		[Parameter(mandatory=$false,position=3)]$computer="localhost",
		[Parameter(mandatory=$false,position=4)][switch]$security
	)
	BEGIN{
		$events=@()
		try{
			if($log -eq "security" -and $security){
				if($computer -eq "localhost"){
					if(!($days)){
					   $Allinfo = Get-EventLog -LogName $log -EntryType Successaudit,Failureaudit 
					}
					else{
						$Allinfo = Get-EventLog -LogName $log -EntryType Successaudit,Failureaudit  -After ([Datetime]::Now.AddDays(-$days))
					}
				}
				else{
					if($days){
						$Allinfo = Get-EventLog -LogName $log -EntryType Successaudit,Failureaudit -ComputerName $computer |  select *  
					}
					else{
						$Allinfo = Get-EventLog -LogName $log -EntryType Successaudit,Failureaudit -ComputerName $computer -After ([Datetime]::Now.AddDays(-$days)) |  select *  
					}
				}
			}
			else{
				if($computer -eq "localhost"){
					if(!($days)){
						$Allinfo = Get-EventLog -LogName "$log" -EntryType Error,Warning |  select * 
					}
					else{
						$Allinfo = Get-EventLog -LogName "$log" -EntryType Error,Warning -After ([Datetime]::Now.AddDays(-$days))|  select * 
					}
				}
				else{
					if($days){
						$Allinfo = Get-EventLog -LogName "$log" -EntryType Error,Warning  -ComputerName $computer| select *  # | Where-Object{ $_.EventID -eq 7045}
					}
					else{
						$Allinfo = Get-EventLog -LogName "$log" -EntryType Error,Warning  -ComputerName $computer -After ([Datetime]::Now.AddDays(-$days)) | select *  # | Where-Object{ $_.EventID -eq 7045}
					}
				}
			}
		}
		catch{
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			Write-log -Level Error -Message "$ErrorMessage LogName: '$log'"
		   
			break;
		}
	}
	PROCESS{
		if( [String]::IsNullOrEmpty($Allinfo) ){
			Write-Log -Level Error -Message "Script Stopped, in function FrequencyData, variable Allinfo is empty"
			Write-Log -Level Error -Message "Exit with error"
			break;

		}
		else{
			$i=0;
			[array]$j= Get-CaoticRandoms $Allinfo.Count
			foreach($event in $Allinfo){
				if(! (checkExists $event.EventID $events)){
					$TimeObject = LastWrittenTime -colection $Allinfo  -EventID $event.EventID
					$TempObj = New-Object PSObject -Property @{
						EventID = $event.EventID
						Count = CheckCount $event.EventID $Allinfo
						color = AssignColor
						EntryType = $event.EntryType
						Source =$event.Source
						Message = $event.Message
						FirstTimeWritten=[convert]::ToString($TimeObject.first)
						LastTimeWritten=[convert]::ToString($TimeObject.last)
					}
					if($TempObj.Count -ge $minimun){
						$events+=$TempObj
					}
				}
			}
		}
	}
	END{
		return $events
	}
}
function ShowTimeMS{
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline=$True,position=0,mandatory=$true)][ValidateNotNull()]	[datetime]$timeStart,
		[parameter(ValueFromPipeline=$True,position=1,mandatory=$true)][ValidateNotNull()]	[datetime]$timeEnd
	)
	BEGIN {}
	PROCESS {
	write-Log -Level Info -Message  "Stamping time"
	
	$diff = New-TimeSpan $TimeStart $TimeEnd
	#Write-Verbose "Timediff= $diff"
	$seconds = $diff.TotalSeconds
	}
	END{
		Write-Log -Level Info -Message  "Total Time (in seconds was): $seconds s"
	}
}
#endregion

#######11111111111111########
####  Get step all users ####
#############################

#Start Script, with or W/o computer switch
Write-Log -level Info -Message "Starting Script"


try{
	if($IncludeSecurity){
		Write-Log -Level Load -Message "Getting System log Information"
		if($computerp -ne $null){
			$SystemData = FrequencyData -log System -minimun $MinimunRepetitions -security:$IncludeSecurity
		}
		else{
			$SystemData = FrequencyData -log System -minimun $MinimunRepetitions -computer $computerp -security:$IncludeSecurity
		}
		
		Write-Log -Level Load -Message "Getting Application log Information"
		#application
		if($computerp  -ne $null){
			$Appdata = FrequencyData -log Application -minimun $MinimunRepetitions -security:$IncludeSecurity
		}
		else{
			$Appdata = FrequencyData -log Application -minimun $MinimunRepetitions -computer $computerp -security:$IncludeSecurity
		}
		
		Write-Log -Level Load -Message "Getting Security log Information, this can take a while"
		#security
		if($computerp  -ne $null){
			$SecData = FrequencyData -log Security -minimun $MinimunRepetitions -security:$IncludeSecurity
		}
		else{
			$SecData = FrequencyData -log Security -minimun $MinimunRepetitions -computer $computerp -security:$IncludeSecurity
		}
	}
	else{
		Write-Log -Level Load -Message "Getting System log Information"
		if($computerp -ne $null){
			$SystemData = FrequencyData -log System -minimun $MinimunRepetitions
		}
		else{
			$SystemData = FrequencyData -log System -minimun $MinimunRepetitions -computer $computerp
		}
		
		Write-Log -Level Load -Message "Getting Application log Information"
		#application
		if($computerp  -ne $null){
			$Appdata = FrequencyData -log Application -minimun $MinimunRepetitions
		}
		else{
			$Appdata = FrequencyData -log Application -minimun $MinimunRepetitions -computer $computerp
		}
	}
}
catch{
	$ErrorMessage = $_.Exception.Message
	$FailedItem = $_.Exception.ItemName
	Write-log -Level Error -Message "$ErrorMessage with source in $FailedItem"
	break;
}

#cleanup
$cleanUpLocal+="SystemData"
$cleanUpLocal+="Appdata"
if($IncludeSecurity){
	$cleanUpLocal+="SecData"
}



#######22222222222222########
####    Check Version    ####
#############################
Write-Log -Level info -Message "Getting PS Version. Works with PS version 3.0 or higher"
Write-Log -Level Info -Message "Converting Data to JSON"
$version = GetPSVersion;
if($version -le 2){
	Write-Log -Level Error -Message "you need to have at least powershell version 3 for this script to run properly"
	exit(-1)

	#not implemented for PS 2.0
	#Export JsonData
	#Write-Log -Level Info -Message "Exporting JSON data"
	#$SystemData | Sort-Object Count | ConvertTo-Json20 | Out-File $jsonsystem
	#$Appdata  | Sort-Object Count | ConvertTo-Json20 | Out-File $jsonapplication
	#if($IncludeSecurity){
	#	$SecData | Sort-Object Count | ConvertTo-Json20 | Out-File $jsonsecurity
	#}
}
else{
	#convert to json version 3 or 4
    $jsondate = Get-Date -Format MMddYYYY
	$SystemDataJSON = $SystemData | Sort-Object Count -Descending | ConvertTo-Json
	$SystemDataJSON | out-file "$global:ScriptLocation\$computerp-system-$today.json"
	
	$AppDataJSON = $Appdata       | Sort-Object Count -Descending | ConvertTo-Json
	$AppDataJSON | out-file "$global:ScriptLocation\$computerp-application-$today.json"
	#cleanup
	$cleanUpLocal+="SystemDataJSON"
	$cleanUpLocal+="AppDataJSON"
	
	if($IncludeSecurity){
		$SecDataJSON = $SecData       | Sort-Object Count -Descending | ConvertTo-Json
		$SecDataJSON | out-file "$global:ScriptLocation\$computerp-security-$today.json"
		#cleanup
		$cleanUpLocal+="SecDataJSON"
	}

	
	


  

	Write-Log -Level Info -Message "Creating graph.js file"
}	
		Try
		{
			if($IncludeSecurity){
				CreateJS -SystemData $SystemDataJSON -AppData $AppDataJSON -SecData $SecDataJSON -ErrorAction Stop 
			}
			else{
				CreateJS -SystemData $SystemDataJSON -AppData $AppDataJSON -ErrorAction Stop 
			}
		}
		Catch
		{
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			$countS= $SystemDataJSON.Count
			$countA =$AppDataJSON.Count
			if($IncludeSecurity){
				$countSec=$SecDataJSON.Count
				$cleanUpLocal+="countSec"
			}
			$cleanUpLocal+="countS"
			$cleanUpLocal+="countA"
			if($IncludeSecurity){
				Write-Output "System Count Objects: $countS, App Count Objects: $countA and Security Objects Count:$countSec, must be all three greather than 0 (not empty)"
				Write-Log -Level Error -Message "System Count Objects: $SystemDataJSON.Count, App Count Objects: $AppDataJSON.Count and Security Objects Count:$SecDataJSON.Count, must be all three greathenr than 0 (not empty)"
			}
			else{
				Write-Output "System Count Objects: $countS, App Count Objects: $countA.Count, must be all three greather than 0 (not empty)"
				Write-Log -Level Error -Message "System Count Objects: $SystemDataJSON.Count, App Count Objects: $AppDataJSON.Count, must be all three greathenr than 0 (not empty)"
			}
			
			$TimeEnd=Get-Date
			showTimeMS $TimeStart $TimeEnd
			Break
			#Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
			
		}
		


	Write-Log -Level Info -Message "Creating $html file"
	CreateHtml -filename "$html" -IncludeSecurity:$IncludeSecurity

	Write-Log -Level Info "Cleaning up variables"
	$cleanUpLocal | ForEach-Object{
		Remove-Variable $_
	}
	$CleanUpGlobal | ForEach-Object{
		Remove-Variable -Scope global $_
	}


	$TimeEnd=Get-Date
	showTimeMS $TimeStart $TimeEnd
	
	Write-Log -Level Info -Message "Finished"

	#cleanup
	Remove-Variable -Scope global -Name DefaultLog
	Remove-Variable CleanUpGlobal,cleanUpLocal,TimeEnd,TimeStart

	
