On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim returncode, name, perfdata,message

arrComputers = Array(".")
For Each strComputer In arrComputers

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("select * from Win32_PerfFormattedData_Tcpip_NetworkInterface", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
	returncode=0
	name="wmiperf_Tcpip_NetworkInterface_" & replace(replace(objItem.Name," ","_"),":","")
	perfdata="OutputQueueLength=" & objItem.OutputQueueLength
	message="OK " & "OutputQueueLength=" & objItem.OutputQueueLength
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
Next

