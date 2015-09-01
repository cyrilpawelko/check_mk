On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim returncode, name, perfdata,message

arrComputers = Array(".")
For Each strComputer In arrComputers

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
	returncode=0
	name="wmiperf_PerfDisk_PhysicalDisk_" & replace(replace(objItem.Name," ","_"),":","")
	perfdata="AvgDiskQueueLength=" & objItem.AvgDiskQueueLength & "|CurrentDiskQueueLength=" & objItem.CurrentDiskQueueLength & "|AvgDiskWriteQueueLength=" & objItem.AvgDiskWriteQueueLength & "|AvgDiskReadQueueLength=" & objItem.AvgDiskReadQueueLength
	message="OK " & "AvgDiskQueueLength=" & objItem.AvgDiskQueueLength & " CurrentDiskQueueLength=" & objItem.CurrentDiskQueueLength & " AvgDiskWriteQueueLength=" & objItem.AvgDiskWriteQueueLength & " AvgDiskReadQueueLength=" & objItem.AvgDiskReadQueueLength
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
Next
