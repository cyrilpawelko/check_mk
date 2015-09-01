On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim returncode, name, perfdata,message

arrComputers = Array(".")
For Each strComputer In arrComputers

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("select * from Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
	returncode=0
	name="wmiperf_PerfOS_Processor_" & replace(replace(objItem.Name," ","_"),":","")
	perfdata="PercentInterruptTime=" & objItem.PercentInterruptTime & "|PercentDPCTime=" & objItem.PercentDPCTime & "|PercentPrivilegedTime=" & objItem.PercentPrivilegedTime
	message="OK " & "PercentInterruptTime=" & objItem.PercentInterruptTime & "|PercentDPCTime=" & objItem.PercentDPCTime & "|PercentPrivilegedTime=" & objItem.PercentPrivilegedTime
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
Next
