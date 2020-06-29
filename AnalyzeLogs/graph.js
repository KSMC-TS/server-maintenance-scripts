
	var chart;
	var SystemData =[
    {
        "FirstTimeWritten":  "6/10/2020 4:11:20 PM",
        "Count":  1553,
        "EventID":  10016,
        "color":  "#457986",
        "LastTimeWritten":  "6/28/2020 5:52:15 PM",
        "Source":  "DCOM",
        "EntryType":  2,
        "Message":  "The description for Event ID \u002710016\u0027 in Source \u0027DCOM\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027application-specific\u0027, \u0027Local\u0027, \u0027Activation\u0027, \u0027{2593F8B9-4EAF-457C-B68A-50F6B8EA6B54}\u0027, \u0027{15C20B67-12E7-4BB6-92BB-7AFF07997402}\u0027, \u0027KSMC\u0027, \u0027fgottman\u0027, \u0027S-1-12-1-1072682238-1252061440-1317597866-3560935018\u0027, \u0027LocalHost (Using LRPC)\u0027, \u0027Unavailable\u0027, \u0027Unavailable\u0027"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:39:36 PM",
        "Count":  80,
        "EventID":  10010,
        "color":  "#851818",
        "LastTimeWritten":  "6/28/2020 2:05:07 AM",
        "Source":  "DCOM",
        "EntryType":  1,
        "Message":  "The description for Event ID \u002710010\u0027 in Source \u0027DCOM\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027{9A4948D9-13FC-4FAC-B60A-FBA6EE0FB11C}\u0027"
    },
    {
        "FirstTimeWritten":  "6/11/2020 8:44:04 AM",
        "Count":  72,
        "EventID":  11,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 5:29:18 PM",
        "Source":  "Kerberos",
        "EntryType":  1,
        "Message":  "The Distinguished Name in the subject field of your smart card logon certificate does not contain enough information to identify the appropriate domain on an non-domain joined computer. Contact your system administrator."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:43:59 PM",
        "Count":  53,
        "EventID":  219,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/27/2020 6:33:33 PM",
        "Source":  "Microsoft-Windows-Kernel-PnP",
        "EntryType":  2,
        "Message":  "The driver \\Driver\\WudfRd failed to load for the device DISPLAY\\SHP14B3\\4\u0026374b2b33\u00260\u0026UID8388688."
    },
    {
        "FirstTimeWritten":  "6/10/2020 5:29:14 PM",
        "Count":  52,
        "EventID":  700,
        "color":  "#457986",
        "LastTimeWritten":  "6/28/2020 7:45:22 AM",
        "Source":  "Win32k",
        "EntryType":  2,
        "Message":  "Power Manager has requested suppression of all input (INPUT_SUPPRESS_REQUEST=1)"
    },
    {
        "FirstTimeWritten":  "6/11/2020 8:43:56 AM",
        "Count":  52,
        "EventID":  701,
        "color":  "#022E38",
        "LastTimeWritten":  "6/28/2020 8:33:49 AM",
        "Source":  "Win32k",
        "EntryType":  2,
        "Message":  "Power Manager has not requested suppression of all input (INPUT_SUPPRESS_REQUEST=0)"
    },
    {
        "FirstTimeWritten":  "6/13/2020 9:55:35 PM",
        "Count":  42,
        "EventID":  1014,
        "color":  "#D86D6D",
        "LastTimeWritten":  "6/28/2020 3:48:14 PM",
        "Source":  "Microsoft-Windows-DNS-Client",
        "EntryType":  2,
        "Message":  "Name resolution for the name wpad timed out after none of the configured DNS servers responded."
    },
    {
        "FirstTimeWritten":  "6/11/2020 8:43:56 AM",
        "Count":  32,
        "EventID":  10317,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/28/2020 10:30:10 AM",
        "Source":  "Microsoft-Windows-NDIS",
        "EntryType":  1,
        "Message":  "Miniport Microsoft Wi-Fi Direct Virtual Adapter #2, {c2ef5e62-0132-4934-b562-5414578704fd}, had event 74"
    },
    {
        "FirstTimeWritten":  "6/12/2020 11:44:23 AM",
        "Count":  22,
        "EventID":  13,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/28/2020 4:00:29 PM",
        "Source":  "SurfaceTconDriver",
        "EntryType":  1,
        "Message":  "Surface Tcon Driver TP Read fails, Status = 0xc0000186"
    },
    {
        "FirstTimeWritten":  "6/12/2020 11:44:23 AM",
        "Count":  22,
        "EventID":  12,
        "color":  "#D86D6D",
        "LastTimeWritten":  "6/28/2020 4:00:29 PM",
        "Source":  "SurfaceTconDriver",
        "EntryType":  1,
        "Message":  "Surface Tcon Driver TP Write fails, Status = 0xc0000186"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:45:12 PM",
        "Count":  14,
        "EventID":  37,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/27/2020 6:34:37 PM",
        "Source":  "Microsoft-Windows-Kernel-Processor-Power",
        "EntryType":  2,
        "Message":  "The speed of Hyper-V logical processor 7 is being limited by system firmware. The processor has been in this reduced performance state for 71 seconds since the last report."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:12:35 PM",
        "Count":  10,
        "EventID":  20,
        "color":  "#114652",
        "LastTimeWritten":  "6/27/2020 11:41:23 PM",
        "Source":  "Microsoft-Windows-WindowsUpdateClient",
        "EntryType":  1,
        "Message":  "Installation Failure: Windows failed to install the following update with error 0x80073d02: 9NMPJ99VJBWV-Microsoft.YourPhone."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:40:01 PM",
        "Count":  8,
        "EventID":  10002,
        "color":  "#457986",
        "LastTimeWritten":  "6/27/2020 6:33:03 PM",
        "Source":  "Microsoft-Windows-WLAN-AutoConfig",
        "EntryType":  2,
        "Message":  "WLAN Extensibility Module has stopped.\r\n\r\nModule Path: C:\\WINDOWS\\system32\\IntelIHVRouter08.dll\r\n"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:43:57 PM",
        "Count":  8,
        "EventID":  157,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/27/2020 6:33:17 PM",
        "Source":  "Microsoft-Windows-Hyper-V-Hypervisor",
        "EntryType":  2,
        "Message":  "The hypervisor did not enable mitigations for CVE-2018-3646 for virtual machines because HyperThreading is enabled and the hypervisor core scheduler is not enabled. To enable mitigations for CVE-2018-3646 for virtual machines, enable the core scheduler by running \"bcdedit /set hypervisorschedulertype core\" from an elevated command prompt and reboot."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:40:00 PM",
        "Count":  6,
        "EventID":  10149,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/27/2020 6:33:02 PM",
        "Source":  "WinRM",
        "EntryType":  2,
        "Message":  "The description for Event ID \u0027468901\u0027 in Source \u0027WinRM\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:"
    },
    {
        "FirstTimeWritten":  "6/12/2020 9:42:10 AM",
        "Count":  5,
        "EventID":  2,
        "color":  "#FFD5AB",
        "LastTimeWritten":  "6/26/2020 8:34:05 AM",
        "Source":  "HidBth",
        "EntryType":  2,
        "Message":  "Bluetooth HID device  either went out of range or became unresponsive."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:40:00 PM",
        "Count":  4,
        "EventID":  7043,
        "color":  "#014801",
        "LastTimeWritten":  "6/18/2020 12:45:56 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "The Trend Micro Security Agent Listener service did not shut down properly after receiving a preshutdown control."
    },
    {
        "FirstTimeWritten":  "6/16/2020 8:27:01 AM",
        "Count":  4,
        "EventID":  7031,
        "color":  "#014801",
        "LastTimeWritten":  "6/27/2020 6:38:06 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "The Trend Micro Security Agent RealTime Scan service terminated unexpectedly.  It has done this 2 time(s).  The following corrective action will be taken in 60000 milliseconds: Restart the service."
    },
    {
        "FirstTimeWritten":  "6/18/2020 12:49:12 PM",
        "Count":  3,
        "EventID":  3,
        "color":  "#2F8B2F",
        "LastTimeWritten":  "6/18/2020 12:49:12 PM",
        "Source":  "Microsoft-Windows-FilterManager",
        "EntryType":  1,
        "Message":  "Filter Manager failed to attach to volume \u0027\\Device\\HarddiskVolume6\u0027.  This volume will be unavailable for filtering until a reboot.  The final status was 0xc03a001c."
    },
    {
        "FirstTimeWritten":  "6/15/2020 8:28:09 PM",
        "Count":  3,
        "EventID":  7011,
        "color":  "#57AD57",
        "LastTimeWritten":  "6/17/2020 11:56:06 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "A timeout (30000 milliseconds) was reached while waiting for a transaction response from the CredentialEnrollmentManagerUserSvc_73adb service."
    },
    {
        "FirstTimeWritten":  "6/20/2020 6:43:07 PM",
        "Count":  2,
        "EventID":  5002,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/21/2020 8:28:09 PM",
        "Source":  "Netwtw08",
        "EntryType":  1,
        "Message":  "Intel(R) Wi-Fi 6 AX201 160MHz : Has determined that the network adapter is not functioning properly."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:44:58 PM",
        "Count":  2,
        "EventID":  7023,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/16/2020 8:27:36 AM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "The SysMain service terminated with the following error: \r\n%%87"
    },
    {
        "FirstTimeWritten":  "6/16/2020 8:18:51 AM",
        "Count":  2,
        "EventID":  7034,
        "color":  "#AE743B",
        "LastTimeWritten":  "6/20/2020 2:10:08 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "The Windows License Manager Service service terminated unexpectedly.  It has done this 1 time(s)."
    },
    {
        "FirstTimeWritten":  "6/20/2020 6:43:06 PM",
        "Count":  2,
        "EventID":  5005,
        "color":  "#5A2D01",
        "LastTimeWritten":  "6/21/2020 8:28:09 PM",
        "Source":  "Netwtw08",
        "EntryType":  1,
        "Message":  "Intel(R) Wi-Fi 6 AX201 160MHz : Has encountered an internal error and has failed."
    },
    {
        "FirstTimeWritten":  "6/20/2020 6:43:07 PM",
        "Count":  2,
        "EventID":  10400,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/21/2020 8:28:09 PM",
        "Source":  "Microsoft-Windows-NDIS",
        "EntryType":  2,
        "Message":  "The network interface \"Intel(R) Wi-Fi 6 AX201 160MHz\" has begun resetting.  There will be a momentary disruption in network connectivity while the hardware resets. Reason: 3. This network interface has reset 2 time(s) since it was last initialized."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:00:16 PM",
        "Count":  1,
        "EventID":  258,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/11/2020 2:00:16 PM",
        "Source":  "IntcOED",
        "EntryType":  1,
        "Message":  "The description for Event ID \u0027258\u0027 in Source \u0027IntcOED\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027\u0027"
    },
    {
        "FirstTimeWritten":  "6/15/2020 10:17:31 PM",
        "Count":  1,
        "EventID":  6105,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/15/2020 10:17:31 PM",
        "Source":  "Netwtw08",
        "EntryType":  2,
        "Message":  "6105 - deauth after EAPOL key exchange sequence"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:00:22 PM",
        "Count":  1,
        "EventID":  34,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/11/2020 2:00:22 PM",
        "Source":  "IntcOED",
        "EntryType":  1,
        "Message":  "The description for Event ID \u0027-270532574\u0027 in Source \u0027IntcOED\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027\u0027"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:00:16 PM",
        "Count":  1,
        "EventID":  21,
        "color":  "#854E18",
        "LastTimeWritten":  "6/11/2020 2:00:16 PM",
        "Source":  "Intel-SST-OED",
        "EntryType":  1,
        "Message":  "Change driver state. Failed to exit D0 state for bus manager, STATUS = 3221225473."
    },
    {
        "FirstTimeWritten":  "6/25/2020 8:50:57 AM",
        "Count":  1,
        "EventID":  161,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/25/2020 8:50:57 AM",
        "Source":  "volmgr",
        "EntryType":  1,
        "Message":  "Dump file creation failed due to error during dump creation."
    },
    {
        "FirstTimeWritten":  "6/25/2020 8:51:08 AM",
        "Count":  1,
        "EventID":  6008,
        "color":  "#5A0101",
        "LastTimeWritten":  "6/25/2020 8:51:08 AM",
        "Source":  "EventLog",
        "EntryType":  1,
        "Message":  "The previous system shutdown at 8:48:49 AM on ‎6/‎25/‎2020 was unexpected."
    },
    {
        "FirstTimeWritten":  "6/25/2020 8:51:09 AM",
        "Count":  1,
        "EventID":  1001,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/25/2020 8:51:09 AM",
        "Source":  "BugCheck",
        "EntryType":  1,
        "Message":  "The description for Event ID \u00271073742825\u0027 in Source \u0027BugCheck\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u00270x0000014f (0x0000000000000004, 0x0000000000000001, 0xffff97826d3a92e0, 0xffffa785e0abf490)\u0027, \u0027C:\\WINDOWS\\MEMORY.DMP\u0027, \u002700000000-0000-0000-0000-000000000000\u0027"
    },
    {
        "FirstTimeWritten":  "6/25/2020 8:51:09 AM",
        "Count":  1,
        "EventID":  1005,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/25/2020 8:51:09 AM",
        "Source":  "BugCheck",
        "EntryType":  1,
        "Message":  "The description for Event ID \u00271073742829\u0027 in Source \u0027BugCheck\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:"
    },
    {
        "FirstTimeWritten":  "6/19/2020 11:15:44 PM",
        "Count":  1,
        "EventID":  7000,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/19/2020 11:15:44 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "The Background Intelligent Transfer Service service failed to start due to the following error: \r\n%%1053"
    },
    {
        "FirstTimeWritten":  "6/19/2020 11:15:44 PM",
        "Count":  1,
        "EventID":  7009,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/19/2020 11:15:44 PM",
        "Source":  "Service Control Manager",
        "EntryType":  1,
        "Message":  "A timeout was reached (30000 milliseconds) while waiting for the Background Intelligent Transfer Service service to connect."
    },
    {
        "FirstTimeWritten":  "6/24/2020 2:49:05 AM",
        "Count":  1,
        "EventID":  6062,
        "color":  "#D8A26D",
        "LastTimeWritten":  "6/24/2020 2:49:05 AM",
        "Source":  "Netwtw08",
        "EntryType":  2,
        "Message":  "6062 - Lso was triggered"
    },
    {
        "FirstTimeWritten":  "6/19/2020 11:15:44 PM",
        "Count":  1,
        "EventID":  10005,
        "color":  "#022E38",
        "LastTimeWritten":  "6/19/2020 11:15:44 PM",
        "Source":  "DCOM",
        "EntryType":  1,
        "Message":  "The description for Event ID \u002710005\u0027 in Source \u0027DCOM\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u00271053\u0027, \u0027BITS\u0027, \u0027Unavailable\u0027, \u0027{4991D34B-80A1-4291-83B6-3328366B9097}\u0027"
    }
];
	var appData =[
    {
        "FirstTimeWritten":  "5/18/2020 6:04:26 PM",
        "Count":  2827,
        "EventID":  100,
        "color":  "#5A0101",
        "LastTimeWritten":  "6/28/2020 3:48:03 PM",
        "Source":  "Bonjour Service",
        "EntryType":  1,
        "Message":  "Local Hostname KSMC-SL22.local already in use; will try KSMC-SL22-2.local instead"
    },
    {
        "FirstTimeWritten":  "5/18/2020 5:25:12 PM",
        "Count":  1352,
        "EventID":  0,
        "color":  "#014801",
        "LastTimeWritten":  "6/28/2020 4:31:36 PM",
        "Source":  "ScreenConnect Client",
        "EntryType":  1,
        "Message":  "System.Net.Sockets.SocketException (0x80004005): No such host is known\r\n   at System.Net.Dns.GetAddrInfo(String name)\r\n   at System.Net.Dns.InternalGetHostByName(String hostName, Boolean includeIPv6)\r\n   at System.Net.Dns.GetHostEntry(String hostNameOrAddress)\r\n   at ScreenConnect.NetworkExtensions.GetIPAddresses(String hostOrIPAddressString)\r\n   at ScreenConnect.ClientNetworkExtensions.ConnectTcpSocket(Uri endPointUri)\r\n   at ScreenConnect.WindowsClientToolkit.ConnectNetworkConnection(Uri endPointUri, Uri httpProxyUri)\r\n   at ScreenConnect.SocketEndPointManager.Run()"
    },
    {
        "FirstTimeWritten":  "5/18/2020 5:25:11 PM",
        "Count":  658,
        "EventID":  514,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 4:31:35 PM",
        "Source":  "SurfaceOemPanel",
        "EntryType":  1,
        "Message":  "The description for Event ID \u0027-1073675774\u0027 in Source \u0027SurfaceOemPanel\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:"
    },
    {
        "FirstTimeWritten":  "5/19/2020 10:26:58 PM",
        "Count":  509,
        "EventID":  512,
        "color":  "#AE743B",
        "LastTimeWritten":  "6/28/2020 10:46:10 AM",
        "Source":  "SurfaceOemPanel",
        "EntryType":  1,
        "Message":  "The description for Event ID \u0027-1073675776\u0027 in Source \u0027SurfaceOemPanel\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027CSC HW 255\u0027, \u0027ReGamma HW 0\u0027, \u0027DeGamma HW 0\u0027, \u0027Computed 4952621\u0027, \u0027Computed 1080959\u0027, \u0027Computed 83336826\u0027"
    },
    {
        "FirstTimeWritten":  "5/22/2020 2:45:19 PM",
        "Count":  300,
        "EventID":  10010,
        "color":  "#022E38",
        "LastTimeWritten":  "6/27/2020 4:04:52 PM",
        "Source":  "Microsoft-Windows-RestartManager",
        "EntryType":  2,
        "Message":  "Application \u0027C:\\Program Files\\Microsoft Office\\root\\Office16\\OUTLOOK.EXE\u0027 (pid 9232) cannot be restarted - 1."
    },
    {
        "FirstTimeWritten":  "5/28/2020 12:12:50 AM",
        "Count":  238,
        "EventID":  513,
        "color":  "#114652",
        "LastTimeWritten":  "6/9/2020 3:37:18 PM",
        "Source":  "SurfaceOemPanel",
        "EntryType":  1,
        "Message":  "The description for Event ID \u0027-1073675775\u0027 in Source \u0027SurfaceOemPanel\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:"
    },
    {
        "FirstTimeWritten":  "5/18/2020 5:13:51 PM",
        "Count":  121,
        "EventID":  64,
        "color":  "#6E98A1",
        "LastTimeWritten":  "6/28/2020 10:33:45 AM",
        "Source":  "AutoEnrollment",
        "EntryType":  2,
        "Message":  "The description for Event ID \u0027-2147483584\u0027 in Source \u0027AutoEnrollment\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027local system\u0027, \u0027eb 0e b7 75 89 fb e7 4d 0a 79 dc a9 60 8c 96 89 9d 12 90 87\u0027"
    },
    {
        "FirstTimeWritten":  "5/19/2020 8:17:04 AM",
        "Count":  53,
        "EventID":  3,
        "color":  "#5A2D01",
        "LastTimeWritten":  "6/28/2020 4:00:24 PM",
        "Source":  "SurfaceCFUOverHid",
        "EntryType":  2,
        "Message":  "The description for Event ID \u0027-2147418109\u0027 in Source \u0027SurfaceCFUOverHid\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027HardwareId={5E9A8CDC-14AB-4609-A017-68BCE594AB68}\\SurfaceDockFwUpdate\u0027, \u0027ntStatus=0xc000000f\u0027"
    },
    {
        "FirstTimeWritten":  "5/20/2020 9:23:44 AM",
        "Count":  34,
        "EventID":  10,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/21/2020 6:50:19 PM",
        "Source":  "Microsoft-Windows-AppModel-State",
        "EntryType":  1,
        "Message":  "The description for Event ID \u002710\u0027 in Source \u0027Microsoft-Windows-AppModel-State\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u0027Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\u0027, \u0027-2147024864\u0027"
    },
    {
        "FirstTimeWritten":  "5/19/2020 8:18:23 AM",
        "Count":  28,
        "EventID":  1000,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/27/2020 6:37:58 PM",
        "Source":  "Application Error",
        "EntryType":  1,
        "Message":  "Faulting application name: ntrtscan.exe, version: 14.2.0.1176, time stamp: 0x5ed9b42a\r\nFaulting module name: tmbmcli.dll, version: 2.98.0.1242, time stamp: 0x5d834b9e\r\nException code: 0xc0000005\r\nFault offset: 0x0000000000171537\r\nFaulting process id: 0x2954\r\nFaulting application start time: 0x01d64cd347171222\r\nFaulting application path: C:\\Program Files (x86)\\Trend Micro\\Client Server Security Agent\\ntrtscan.exe\r\nFaulting module path: C:\\Program Files (x86)\\Trend Micro\\Client Server Security Agent\\tmbmcli.dll\r\nReport Id: 31ddab9a-966d-4f66-8b60-e350ab1f1d51\r\nFaulting package full name: \r\nFaulting package-relative application ID: "
    },
    {
        "FirstTimeWritten":  "5/19/2020 12:02:10 AM",
        "Count":  26,
        "EventID":  10023,
        "color":  "#275E6C",
        "LastTimeWritten":  "6/28/2020 7:55:36 AM",
        "Source":  "Windows Search Service",
        "EntryType":  2,
        "Message":  "The protocol host process 34504 did not respond and is being forcibly terminated {filter host process 0}. \n"
    },
    {
        "FirstTimeWritten":  "5/23/2020 3:37:57 PM",
        "Count":  16,
        "EventID":  13,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/27/2020 6:33:02 PM",
        "Source":  "VSS",
        "EntryType":  1,
        "Message":  "Volume Shadow Copy Service information: The COM Server with CLSID {4e14fba2-2e22-11d1-9964-00c04fbbb345} and name CEventSystem cannot be started. [0x8007045b, A system shutdown is in progress.\r\n]\r\n"
    },
    {
        "FirstTimeWritten":  "5/23/2020 3:37:57 PM",
        "Count":  15,
        "EventID":  8193,
        "color":  "#AE743B",
        "LastTimeWritten":  "6/27/2020 6:33:02 PM",
        "Source":  "VSS",
        "EntryType":  1,
        "Message":  "Volume Shadow Copy Service error: Unexpected error calling routine CoCreateInstance.  hr = 0x8007045b, A system shutdown is in progress.\r\n.\r\n"
    },
    {
        "FirstTimeWritten":  "5/18/2020 12:51:17 PM",
        "Count":  14,
        "EventID":  22,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/26/2020 1:01:38 PM",
        "Source":  "VSS",
        "EntryType":  1,
        "Message":  "Volume Shadow Copy Service error: A critical component required by the Volume Shadow Copy service is not registered.\r\nThis might happened if an error occurred during Windows setup or during installation of a Shadow Copy provider.\r\nThe error returned from CoCreateInstance on class with CLSID {3e02620c-e180-44f3-b154-2473646e4cb8} and Name SW_PROV is [0x80040154, Class not registered\r\n].\r\n\n\nOperation:\n   Obtain a callable interface for this provider\n   List interfaces for all providers supporting this context\n   Query Shadow Copies\n\nContext:\n   Provider ID: {74600e39-7dc5-4567-a03b-f091d6c7b092}\n   Class ID: {3e02620c-e180-44f3-b154-2473646e4cb8}\n   Snapshot Context: -1\n   Snapshot Context: -1\n   Execution Context: Coordinator"
    },
    {
        "FirstTimeWritten":  "5/18/2020 12:51:17 PM",
        "Count":  14,
        "EventID":  12292,
        "color":  "#D86D6D",
        "LastTimeWritten":  "6/26/2020 1:01:38 PM",
        "Source":  "VSS",
        "EntryType":  1,
        "Message":  "Volume Shadow Copy Service error: Error creating the Shadow Copy Provider COM class with CLSID {3e02620c-e180-44f3-b154-2473646e4cb8} [0x80040154, Class not registered\r\n].\r\n\n\nOperation:\n   Obtain a callable interface for this provider\n   List interfaces for all providers supporting this context\n   Query Shadow Copies\n\nContext:\n   Provider ID: {74600e39-7dc5-4567-a03b-f091d6c7b092}\n   Class ID: {3e02620c-e180-44f3-b154-2473646e4cb8}\n   Snapshot Context: -1\n   Snapshot Context: -1\n   Execution Context: Coordinator"
    },
    {
        "FirstTimeWritten":  "5/20/2020 1:17:47 PM",
        "Count":  7,
        "EventID":  1002,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/27/2020 1:34:49 PM",
        "Source":  "Application Hang",
        "EntryType":  1,
        "Message":  "The program SkypeBackgroundHost.exe version 8.56.0.102 stopped interacting with Windows and was closed. To see if more information about the problem is available, check the problem history in the Security and Maintenance control panel.\r\n\r\nProcess ID: da4\r\n\r\nStart Time: 01d64af0868bebef\r\n\r\nTermination Time: 4294967295\r\n\r\nApplication Path: C:\\Program Files\\WindowsApps\\Microsoft.SkypeApp_14.56.102.0_x64__kzf8qxf38zg5c\\SkypeBackgroundHost.exe\r\n\r\nReport Id: 69665b66-7642-48c3-9041-2522297b21a7\r\n\r\nFaulting package full name: Microsoft.SkypeApp_14.56.102.0_x64__kzf8qxf38zg5c\r\n\r\nFaulting package-relative application ID: ppleae38af2e007f4358a809ac99a64a67c1\r\n\r\nHang type: Quiesce\r\n"
    },
    {
        "FirstTimeWritten":  "5/23/2020 4:50:41 PM",
        "Count":  6,
        "EventID":  1020,
        "color":  "#136B13",
        "LastTimeWritten":  "6/25/2020 9:53:12 AM",
        "Source":  "Microsoft-Windows-Perflib",
        "EntryType":  1,
        "Message":  "The required buffer size is greater than the buffer size passed to the Collect function of the \"C:\\Windows\\System32\\perfts.dll\" Extensible Counter DLL for the \"LSM\" service. The given buffer size was 8120 and the required size was 57144."
    },
    {
        "FirstTimeWritten":  "5/18/2020 12:50:11 PM",
        "Count":  6,
        "EventID":  257,
        "color":  "#014801",
        "LastTimeWritten":  "6/23/2020 1:39:37 PM",
        "Source":  "Microsoft-Windows-Defrag",
        "EntryType":  1,
        "Message":  "The volume PortableBaseLayer (C:\\ProgramData\\Microsoft\\Windows\\Containers\\BaseImages\\a2034560-987f-4e35-9fe4-0b48415195a9\\BaseLayer) was not optimized because an error was encountered: The disk was disconnected from the system. (0x89000011)"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:48:07 PM",
        "Count":  4,
        "EventID":  1008,
        "color":  "#854E18",
        "LastTimeWritten":  "6/11/2020 2:48:08 PM",
        "Source":  "Microsoft-Windows-Perflib",
        "EntryType":  2,
        "Message":  "The Open procedure for service \"WmiApRpl\" in DLL \"C:\\WINDOWS\\system32\\wbem\\wmiaprpl.dll\" failed with error code 21. Performance data for this service will not be available."
    },
    {
        "FirstTimeWritten":  "6/3/2020 9:01:46 AM",
        "Count":  2,
        "EventID":  2011,
        "color":  "#854E18",
        "LastTimeWritten":  "6/3/2020 9:01:46 AM",
        "Source":  "Microsoft Office 16",
        "EntryType":  1,
        "Message":  "Office Subscription licensing exception: Error Code: 0x803D0010; CorrelationId: {A1DDC83C-0671-4002-B28D-93ADDE6106F3}"
    },
    {
        "FirstTimeWritten":  "5/20/2020 3:56:31 PM",
        "Count":  2,
        "EventID":  1026,
        "color":  "#851818",
        "LastTimeWritten":  "5/22/2020 2:55:20 PM",
        "Source":  ".NET Runtime",
        "EntryType":  1,
        "Message":  "Application: SurfaceAppDt.exe\nFramework Version: v4.0.30319\nDescription: The process was terminated due to an unhandled exception.\nException Info: System.ArgumentException\n   at System.RuntimeType.IsEnumDefined(System.Object)\n   at SurfaceAppDt.Handedness.HandleGetHandedness(System.String[])\n   at SurfaceAppDt.Handedness.ProcessHandedness(System.String[])\n   at SurfaceAppDt.Program.Main(System.String[])\n\n"
    },
    {
        "FirstTimeWritten":  "6/9/2020 5:47:46 PM",
        "Count":  2,
        "EventID":  11316,
        "color":  "#2F8B2F",
        "LastTimeWritten":  "6/13/2020 9:12:01 PM",
        "Source":  "MsiInstaller",
        "EntryType":  1,
        "Message":  "Product: PowerShell 7-x64 -- Error 1316. The specified account already exists.\r\n"
    },
    {
        "FirstTimeWritten":  "6/9/2020 12:19:21 PM",
        "Count":  2,
        "EventID":  10006,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/13/2020 6:09:37 PM",
        "Source":  "Microsoft-Windows-RestartManager",
        "EntryType":  1,
        "Message":  "Application or service \u0027pwsh\u0027 could not be shut down."
    },
    {
        "FirstTimeWritten":  "5/27/2020 9:56:35 AM",
        "Count":  1,
        "EventID":  249,
        "color":  "#851818",
        "LastTimeWritten":  "5/27/2020 9:56:35 AM",
        "Source":  "PrintixClient",
        "EntryType":  2,
        "Message":  "Printix Service Unavailable"
    },
    {
        "FirstTimeWritten":  "5/26/2020 8:20:56 AM",
        "Count":  1,
        "EventID":  4627,
        "color":  "#2F8B2F",
        "LastTimeWritten":  "5/26/2020 8:20:56 AM",
        "Source":  "EventSystem",
        "EntryType":  2,
        "Message":  "The description for Event ID \u0027-2147479021\u0027 in Source \u0027EventSystem\u0027 cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:\u002780010002\u0027, \u0027DisplayUnlock\u0027, \u0027{D5978630-5B9F-11D1-8DD2-00AA004ABD5E}\u0027, \u0027\u0027, \u0027\u0027, \u0027Explorer\u0027, \u0027180\u0027, \u0027\u0027"
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:48:08 PM",
        "Count":  1,
        "EventID":  2002,
        "color":  "#AE743B",
        "LastTimeWritten":  "6/11/2020 2:48:08 PM",
        "Source":  "Microsoft-Windows-PerfProc",
        "EntryType":  2,
        "Message":  "Unable to open the job object \\BaseNamedObjects\\WmiProviderSubSystemHostJob for query access. The calling process may not have permission to open this job. The first four bytes (DWORD) of the Data section contains the status code."
    },
    {
        "FirstTimeWritten":  "6/1/2020 7:43:56 AM",
        "Count":  1,
        "EventID":  36,
        "color":  "#457986",
        "LastTimeWritten":  "6/1/2020 7:43:56 AM",
        "Source":  "Outlook",
        "EntryType":  2,
        "Message":  "Search cannot complete the indexing of your Outlook data. Indexing cannot continue for C:\\Users\\fgottman\\AppData\\Local\\Microsoft\\Outlook\\fgottman@ksmconsulting.com.ost (error=0x8034081f). If this error continues, contact Microsoft Support."
    },
    {
        "FirstTimeWritten":  "6/11/2020 2:48:07 PM",
        "Count":  1,
        "EventID":  2004,
        "color":  "#57AD57",
        "LastTimeWritten":  "6/11/2020 2:48:07 PM",
        "Source":  "Microsoft-Windows-PerfNet",
        "EntryType":  1,
        "Message":  "Unable to open the Server service performance object. The first four bytes (DWORD) of the Data section contains the status code."
    },
    {
        "FirstTimeWritten":  "6/18/2020 12:45:34 PM",
        "Count":  1,
        "EventID":  6004,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/18/2020 12:45:34 PM",
        "Source":  "Wlclntfy",
        "EntryType":  2,
        "Message":  "The winlogon notification subscriber \u003cTrustedInstaller\u003e failed a critical notification event."
    },
    {
        "FirstTimeWritten":  "6/18/2020 12:49:12 PM",
        "Count":  1,
        "EventID":  1552,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/18/2020 12:49:12 PM",
        "Source":  "Microsoft-Windows-User Profiles Service",
        "EntryType":  1,
        "Message":  "User hive is loaded by another process (Registry Lock) Process name: C:\\Windows\\System32\\svchost.exe, PID: 5888, ProfSvc PID: 3216."
    }
];var secData =[
    {
        "FirstTimeWritten":  "6/22/2020 10:24:19 PM",
        "Count":  30479,
        "EventID":  5379,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 5:57:53 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Credential Manager credentials were read.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x714b9\r\n\tRead Operation:\t\t%%8099\r\n\r\nThis event occurs when a user performs a read operation on stored credentials in Credential Manager."
    },
    {
        "FirstTimeWritten":  "6/22/2020 10:37:52 PM",
        "Count":  1414,
        "EventID":  4624,
        "color":  "#851818",
        "LastTimeWritten":  "6/28/2020 5:56:12 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "An account was successfully logged on.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tKSMC-SL22$\r\n\tAccount Domain:\t\tWORKGROUP\r\n\tLogon ID:\t\t0x3e7\r\n\r\nLogon Information:\r\n\tLogon Type:\t\t5\r\n\tRestricted Admin Mode:\t-\r\n\tVirtual Account:\t\t%%1843\r\n\tElevated Token:\t\t%%1842\r\n\r\nImpersonation Level:\t\t%%1833\r\n\r\nNew Logon:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tSYSTEM\r\n\tAccount Domain:\t\tNT AUTHORITY\r\n\tLogon ID:\t\t0x3e7\r\n\tLinked Logon ID:\t\t0x0\r\n\tNetwork Account Name:\t-\r\n\tNetwork Account Domain:\t-\r\n\tLogon GUID:\t\t{00000000-0000-0000-0000-000000000000}\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t0x504\r\n\tProcess Name:\t\tC:\\Windows\\System32\\services.exe\r\n\r\nNetwork Information:\r\n\tWorkstation Name:\t-\r\n\tSource Network Address:\t-\r\n\tSource Port:\t\t-\r\n\r\nDetailed Authentication Information:\r\n\tLogon Process:\t\tAdvapi  \r\n\tAuthentication Package:\tNegotiate\r\n\tTransited Services:\t-\r\n\tPackage Name (NTLM only):\t-\r\n\tKey Length:\t\t0\r\n\r\nThis event is generated when a logon session is created. It is generated on the computer that was accessed.\r\n\r\nThe subject fields indicate the account on the local system which requested the logon. This is most commonly a service such as the Server service, or a local process such as Winlogon.exe or Services.exe.\r\n\r\nThe logon type field indicates the kind of logon that occurred. The most common types are 2 (interactive) and 3 (network).\r\n\r\nThe New Logon fields indicate the account for whom the new logon was created, i.e. the account that was logged on.\r\n\r\nThe network fields indicate where a remote logon request originated. Workstation name is not always available and may be left blank in some cases.\r\n\r\nThe impersonation level field indicates the extent to which a process in the logon session can impersonate.\r\n\r\nThe authentication information fields provide detailed information about this specific logon request.\r\n\t- Logon GUID is a unique identifier that can be used to correlate this event with a KDC event.\r\n\t- Transited services indicate which intermediate services have participated in this logon request.\r\n\t- Package name indicates which sub-protocol was used among the NTLM protocols.\r\n\t- Key length indicates the length of the generated session key. This will be 0 if no session key was requested."
    },
    {
        "FirstTimeWritten":  "6/22/2020 10:37:52 PM",
        "Count":  1358,
        "EventID":  4672,
        "color":  "#275E6C",
        "LastTimeWritten":  "6/28/2020 5:56:12 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Special privileges assigned to new logon.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tSYSTEM\r\n\tAccount Domain:\t\tNT AUTHORITY\r\n\tLogon ID:\t\t0x3e7\r\n\r\nPrivileges:\t\tSeAssignPrimaryTokenPrivilege\r\n\t\t\tSeTcbPrivilege\r\n\t\t\tSeSecurityPrivilege\r\n\t\t\tSeTakeOwnershipPrivilege\r\n\t\t\tSeLoadDriverPrivilege\r\n\t\t\tSeBackupPrivilege\r\n\t\t\tSeRestorePrivilege\r\n\t\t\tSeDebugPrivilege\r\n\t\t\tSeAuditPrivilege\r\n\t\t\tSeSystemEnvironmentPrivilege\r\n\t\t\tSeImpersonatePrivilege\r\n\t\t\tSeDelegateSessionUserImpersonatePrivilege"
    },
    {
        "FirstTimeWritten":  "6/22/2020 10:24:23 PM",
        "Count":  931,
        "EventID":  5061,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/28/2020 5:53:00 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Cryptographic operation.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x714e2\r\n\r\nCryptographic Parameters:\r\n\tProvider Name:\tMicrosoft Software Key Storage Provider\r\n\tAlgorithm Name:\tRSA\r\n\tKey Name:\tTB_0_live.com\r\n\tKey Type:\t%%2500\r\n\r\nCryptographic Operation:\r\n\tOperation:\t%%2480\r\n\tReturn Code:\t0x0"
    },
    {
        "FirstTimeWritten":  "6/22/2020 10:27:42 PM",
        "Count":  232,
        "EventID":  5382,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 5:23:14 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Vault credentials were read.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tKSMC-SL22$\r\n\tAccount Domain:\t\tWORKGROUP\r\n\tLogon ID:\t\t0x3e7\r\n\r\nThis event occurs when a user reads a stored vault credential."
    },
    {
        "FirstTimeWritten":  "6/23/2020 7:48:24 AM",
        "Count":  157,
        "EventID":  5059,
        "color":  "#6E98A1",
        "LastTimeWritten":  "6/28/2020 4:00:45 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Key migration operation.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-19\r\n\tAccount Name:\t\tLOCAL SERVICE\r\n\tAccount Domain:\t\tNT AUTHORITY\r\n\tLogon ID:\t\t0x3e5\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t5232\r\n\tProcess Creation Time:\t2020-06-27T22:33:35.436013000Z\r\n\r\nCryptographic Parameters:\r\n\tProvider Name:\tMicrosoft Software Key Storage Provider\r\n\tAlgorithm Name:\tRSA\r\n\tKey Name:\t{D0D9B2C0-2AB9-4451-B490-59594A29742F}\r\n\tKey Type:\t%%2500\r\n\r\nAdditional Information:\r\n\tOperation:\t%%2464\r\n\tReturn Code:\t0x0"
    },
    {
        "FirstTimeWritten":  "6/22/2020 10:59:12 PM",
        "Count":  143,
        "EventID":  4799,
        "color":  "#014801",
        "LastTimeWritten":  "6/28/2020 5:45:07 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "A security-enabled local group membership was enumerated.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tKSMC-SL22$\r\n\tAccount Domain:\t\tWORKGROUP\r\n\tLogon ID:\t\t0x3e7\r\n\r\nGroup:\r\n\tSecurity ID:\t\tS-1-5-32-551\r\n\tGroup Name:\t\tBackup Operators\r\n\tGroup Domain:\t\tBuiltin\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t0x9118\r\n\tProcess Name:\t\tC:\\Windows\\System32\\svchost.exe"
    },
    {
        "FirstTimeWritten":  "6/23/2020 7:48:33 AM",
        "Count":  88,
        "EventID":  4634,
        "color":  "#275E6C",
        "LastTimeWritten":  "6/28/2020 4:00:45 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "An account was logged off.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x244255cb\r\n\r\nLogon Type:\t\t\t2\r\n\r\nThis event is generated when a logon session is destroyed. It may be positively correlated with a logon event using the Logon ID value. Logon IDs are only unique between reboots on the same computer."
    },
    {
        "FirstTimeWritten":  "6/23/2020 7:48:25 AM",
        "Count":  83,
        "EventID":  4648,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 5:53:03 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "A logon was attempted using explicit credentials.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x714b9\r\n\tLogon GUID:\t\t{00000000-0000-0000-0000-000000000000}\r\n\r\nAccount Whose Credentials Were Used:\r\n\tAccount Name:\t\thomeass\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon GUID:\t\t{00000000-0000-0000-0000-000000000000}\r\n\r\nTarget Server:\r\n\tTarget Server Name:\thomeass\r\n\tAdditional Information:\thomeass\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t0x4\r\n\tProcess Name:\t\t\r\n\r\nNetwork Information:\r\n\tNetwork Address:\t192.168.1.210\r\n\tPort:\t\t\t445\r\n\r\nThis event is generated when a process attempts to log on an account by explicitly specifying that account’s credentials.  This most commonly occurs in batch-type configurations such as scheduled tasks, or when using the RUNAS command."
    },
    {
        "FirstTimeWritten":  "6/23/2020 7:51:28 AM",
        "Count":  48,
        "EventID":  4798,
        "color":  "#022E38",
        "LastTimeWritten":  "6/27/2020 6:39:29 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "A user\u0027s local group membership was enumerated.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x714e2\r\n\r\nUser:\r\n\tSecurity ID:\t\tS-1-5-21-4131074138-64471047-3311913690-501\r\n\tAccount Name:\t\tGuest\r\n\tAccount Domain:\t\tKSMC-SL22\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t0x57c8\r\n\tProcess Name:\t\tC:\\Windows\\ImmersiveControlPanel\\SystemSettings.exe"
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:32 PM",
        "Count":  40,
        "EventID":  4688,
        "color":  "#022E38",
        "LastTimeWritten":  "6/27/2020 6:33:34 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "A new process has been created.\r\n\r\nCreator Subject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\tLogon ID:\t\t0x3e7\r\n\r\nTarget Subject:\r\n\tSecurity ID:\t\tS-1-0-0\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\tLogon ID:\t\t0x0\r\n\r\nProcess Information:\r\n\tNew Process ID:\t\t0x52c\r\n\tNew Process Name:\tC\r\n\tToken Elevation Type:\t%%1936\r\n\tMandatory Label:\t\tS-1-16-16384\r\n\tCreator Process ID:\t0x47c\r\n\tCreator Process Name:\tC\r\n\tProcess Command Line:\t\r\n\r\nToken Elevation Type indicates the type of token that was assigned to the new process in accordance with User Account Control policy.\r\n\r\nType 1 is a full token with no privileges removed or groups disabled.  A full token is only used if User Account Control is disabled or if the user is the built-in Administrator account or a service account.\r\n\r\nType 2 is an elevated token with no privileges removed or groups disabled.  An elevated token is used when User Account Control is enabled and the user chooses to start the program using Run as administrator.  An elevated token is also used when an application is configured to always require administrative privilege or to always require maximum privilege, and the user is a member of the Administrators group.\r\n\r\nType 3 is a limited token with administrative privileges removed and administrative groups disabled.  The limited token is used when User Account Control is enabled, the application does not require administrative privilege, and the user does not choose to start the program using Run as administrator."
    },
    {
        "FirstTimeWritten":  "6/24/2020 2:07:47 AM",
        "Count":  35,
        "EventID":  4797,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/28/2020 4:57:31 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "An attempt was made to query the existence of a blank password for an account.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x714e2\r\n\r\nAdditional Information:\r\n\tCaller Workstation:\tKSMC-SL22\r\n\tTarget Account Name:\tWDAGUtilityAccount\r\n\tTarget Account Domain:\tKSMC-SL22"
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:45 PM",
        "Count":  30,
        "EventID":  5058,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/28/2020 10:46:12 AM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Key file operation.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-19\r\n\tAccount Name:\t\tLOCAL SERVICE\r\n\tAccount Domain:\t\tNT AUTHORITY\r\n\tLogon ID:\t\t0x3e5\r\n\r\nProcess Information:\r\n\tProcess ID:\t\t5232\r\n\tProcess Creation Time:\t2020-06-27T22:33:35.436013000Z\r\n\r\nCryptographic Parameters:\r\n\tProvider Name:\tMicrosoft Software Key Storage Provider\r\n\tAlgorithm Name:\tUNKNOWN\r\n\tKey Name:\t{D0D9B2C0-2AB9-4451-B490-59594A29742F}\r\n\tKey Type:\t%%2500\r\n\r\nKey File Operation Information:\r\n\tFile Path:\tC:\\WINDOWS\\ServiceProfiles\\LocalService\\AppData\\Roaming\\Microsoft\\Crypto\\Keys\\c98ab9eec30f236cffef340f088e72d5_2abf12ca-e38a-4c82-af81-1daaeed9d9d4\r\n\tOperation:\t%%2458\r\n\tReturn Code:\t0x0"
    },
    {
        "FirstTimeWritten":  "6/23/2020 10:27:34 AM",
        "Count":  12,
        "EventID":  4625,
        "color":  "#AE743B",
        "LastTimeWritten":  "6/28/2020 10:30:47 AM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  16,
        "Message":  "An account failed to log on.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\tKSMC-SL22$\r\n\tAccount Domain:\t\tWORKGROUP\r\n\tLogon ID:\t\t0x3e7\r\n\r\nLogon Type:\t\t\t2\r\n\r\nAccount For Which Logon Failed:\r\n\tSecurity ID:\t\tS-1-0-0\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\r\nFailure Information:\r\n\tFailure Reason:\t\t%%2304\r\n\tStatus:\t\t\t0xc000006d\r\n\tSub Status:\t\t0xc004844c\r\n\r\nProcess Information:\r\n\tCaller Process ID:\t0x1660\r\n\tCaller Process Name:\tC:\\Windows\\LTSvc\\LTSVC.exe\r\n\r\nNetwork Information:\r\n\tWorkstation Name:\t-\r\n\tSource Network Address:\t-\r\n\tSource Port:\t\t-\r\n\r\nDetailed Authentication Information:\r\n\tLogon Process:\t\tAdvapi  \r\n\tAuthentication Package:\tNegotiate\r\n\tTransited Services:\t-\r\n\tPackage Name (NTLM only):\t-\r\n\tKey Length:\t\t0\r\n\r\nThis event is generated when a logon request fails. It is generated on the computer where access was attempted.\r\n\r\nThe Subject fields indicate the account on the local system which requested the logon. This is most commonly a service such as the Server service, or a local process such as Winlogon.exe or Services.exe.\r\n\r\nThe Logon Type field indicates the kind of logon that was requested. The most common types are 2 (interactive) and 3 (network).\r\n\r\nThe Process Information fields indicate which account and process on the system requested the logon.\r\n\r\nThe Network Information fields indicate where a remote logon request originated. Workstation name is not always available and may be left blank in some cases.\r\n\r\nThe authentication information fields provide detailed information about this specific logon request.\r\n\t- Transited services indicate which intermediate services have participated in this logon request.\r\n\t- Package name indicates which sub-protocol was used among the NTLM protocols.\r\n\t- Key length indicates the length of the generated session key. This will be 0 if no session key was requested."
    },
    {
        "FirstTimeWritten":  "6/23/2020 10:56:53 AM",
        "Count":  9,
        "EventID":  4616,
        "color":  "#FFABAB",
        "LastTimeWritten":  "6/27/2020 6:49:07 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "The system time was changed.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-19\r\n\tAccount Name:\t\tLOCAL SERVICE\r\n\tAccount Domain:\t\tNT AUTHORITY\r\n\tLogon ID:\t\t0x3e5\r\n\r\nProcess Information:\r\n\tProcess ID:\t0x2538\r\n\tName:\t\tC:\\Windows\\System32\\svchost.exe\r\n\r\nPrevious Time:\t\t2020-06-27T22:49:07.523168800Z\r\nNew Time:\t\t2020-06-27T22:49:07.523739600Z\r\n\r\nThis event is generated when the system time is changed. It is normal for the Windows Time Service, which runs with System privilege, to change the system time on a regular basis. Other system time changes may be indicative of attempts to tamper with the computer."
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:32 PM",
        "Count":  3,
        "EventID":  4696,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/27/2020 6:33:19 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "A primary token was assigned to process.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\tLogon ID:\t\t0x3e7\r\n\r\nProcess Information:\r\n\tProcess ID:\t0x4\r\n\tProcess Name:\t\r\n\r\nTarget Process:\r\n\tTarget Process ID:\t0x80\r\n\tTarget Process Name:\tRegistry\r\n\r\nNew Token Information:\r\n\tSecurity ID:\t\tS-1-0-0\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\tLogon ID:\t\t0x3e7"
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:32 PM",
        "Count":  3,
        "EventID":  4826,
        "color":  "#275E6C",
        "LastTimeWritten":  "6/27/2020 6:33:19 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Boot Configuration Data loaded.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-18\r\n\tAccount Name:\t\t-\r\n\tAccount Domain:\t\t-\r\n\tLogon ID:\t\t0x3e7\r\n\r\nGeneral Settings:\r\n\tLoad Options:\t\t-\r\n\tAdvanced Options:\t\t%%1843\r\n\tConfiguration Access Policy:\t%%1846\r\n\tSystem Event Logging:\t%%1843\r\n\tKernel Debugging:\t%%1843\r\n\tVSM Launch Type:\t%%1849\r\n\r\nSignature Settings:\r\n\tTest Signing:\t\t%%1843\r\n\tFlight Signing:\t\t%%1843\r\n\tDisable Integrity Checks:\t%%1843\r\n\r\nHyperVisor Settings:\r\n\tHyperVisor Load Options:\t-\r\n\tHyperVisor Launch Type:\t%%1849\r\n\tHyperVisor Debugging:\t%%1843"
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:42 PM",
        "Count":  3,
        "EventID":  4608,
        "color":  "#136B13",
        "LastTimeWritten":  "6/27/2020 6:33:34 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Windows is starting up.\r\n\r\nThis event is logged when LSASS.EXE starts and the auditing subsystem is initialized."
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:45 PM",
        "Count":  3,
        "EventID":  5024,
        "color":  "#D86D6D",
        "LastTimeWritten":  "6/27/2020 6:33:36 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "The Windows Firewall service started successfully."
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:44 PM",
        "Count":  3,
        "EventID":  5033,
        "color":  "#275F6C",
        "LastTimeWritten":  "6/27/2020 6:33:35 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "The Windows Firewall Driver started successfully."
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:42 PM",
        "Count":  3,
        "EventID":  4902,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/27/2020 6:33:34 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "The Per-user audit policy table was created.\r\n\r\nNumber of Elements:\t0\r\nPolicy ID:\t0x13875"
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:19 PM",
        "Count":  2,
        "EventID":  1100,
        "color":  "#114652",
        "LastTimeWritten":  "6/27/2020 6:33:02 PM",
        "Source":  "Microsoft-Windows-Eventlog",
        "EntryType":  8,
        "Message":  "The event logging service has shut down."
    },
    {
        "FirstTimeWritten":  "6/23/2020 11:41:18 PM",
        "Count":  2,
        "EventID":  4647,
        "color":  "#AE3B3B",
        "LastTimeWritten":  "6/27/2020 6:33:01 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "User initiated logoff:\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x32a4b4\r\n\r\nThis event is generated when a logoff is initiated. No further user-initiated activity can occur. This event can be interpreted as a logoff event."
    },
    {
        "FirstTimeWritten":  "6/24/2020 2:25:55 PM",
        "Count":  1,
        "EventID":  5381,
        "color":  "#8ACE8A",
        "LastTimeWritten":  "6/24/2020 2:25:55 PM",
        "Source":  "Microsoft-Windows-Security-Auditing",
        "EntryType":  8,
        "Message":  "Vault credentials were read.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-12-1-1072682238-1252061440-1317597866-3560935018\r\n\tAccount Name:\t\tfgottman\r\n\tAccount Domain:\t\tKSMC\r\n\tLogon ID:\t\t0x31ff5d8\r\n\r\nThis event occurs when a user enumerates stored vault credentials."
    },
    {
        "FirstTimeWritten":  "6/25/2020 8:51:08 AM",
        "Count":  1,
        "EventID":  1101,
        "color":  "#D86D6D",
        "LastTimeWritten":  "6/25/2020 8:51:08 AM",
        "Source":  "Microsoft-Windows-Eventlog",
        "EntryType":  8,
        "Message":  "Audit events have been dropped by the transport.  0"
    }
];
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
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=Yellow>[[EntryType]]</b>",
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
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=Yellow>[[EntryType]]</b>",
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
				"balloonText": "EventID [[category]]</br>Repeated: <b>[[value]]</b> times</br>Source: [[Source]]</br>[[Message]]</br>First on:<b>[[FirstTimeWritten]]</b></br>Last on:<b>[[LastTimeWritten]]</b> </br> <b class=Yellow>[[EntryType]]</b>",
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
});
