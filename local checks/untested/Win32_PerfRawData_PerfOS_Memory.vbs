On Error Resume Next

Const WMIClass = "Win32_PerfRawData_PerfOS_Memory"
Const Index = ""

Dim counters(5)
Counters(0) = "AvailableBytes"
Counters(1) = "PoolNonpagedBytes"
Counters(2) = "PoolPagedBytes"
Counters(3) = "SystemCodeTotalBytes"
Counters(4) = "SystemDriverResidentBytes"

Dim returncode, name, perfdata, message

Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
For Each Counter In Counters
 Query = Query & Counter & ","
Next

Query =  Left(Query ,Len(Query)-1)
Query = "SELECT " & Query & " FROM " & WMIClass

Set colItems = objWMIService.ExecQuery(Query , "WQL", &h30)

For Each objItem In colItems
 returncode=0
  If Index="" Then
	name = "WMI_" & WMIClass
	Else 
		name=WMIClass & "_" & objItem.Contents(Index)
	End If
	perfdata= ""
	message = ""
	For Each prop in objItem.Properties_
	 perfdata = perfdata & prop.Name & "=" & prop.Value & "|"
	 message = message & prop.Name & ":" & prop.Value & " "
	Next
	perfdata = Left (perfdata , Len(perfdata)-1)
	message="OK " & message
      WScript.Echo returncode & " " & name & " " & perfdata & " " & message
   Next
