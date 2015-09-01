On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim returncode, name, perfdata,message

arrComputers = Array(".")
For Each strComputer In arrComputers

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("Select * from Win32_Registry", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
	returncode=0
	name="Win32_Registry" 
	perfdata="CurrentSize=" & objItem.CurrentSize & "|MaximumSize=" & objItem.MaximumSize
	message="OK " & "CurrentSize=" & objItem.CurrentSize & " MaximumSize=" & objItem.MaximumSize
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
Next
