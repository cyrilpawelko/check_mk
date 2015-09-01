On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim returncode, name, perfdata,message

arrComputers = Array(".")
For Each strComputer In arrComputers

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("select HandleCount from Win32_PerfFormattedData_PerfProc_Process where name='_Total'", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
	returncode=0
	name="Win32_PerfFormattedData_PerfProc_Process_" & replace(replace(objItem.Name," ","_"),":","")
	perfdata="HandleCount=" & objItem.HandleCount
	message="OK " & "HandleCount=" & objItem.HandleCount
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
Next
