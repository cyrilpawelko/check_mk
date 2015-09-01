# Pygram - Cyril - 09/04/2014 - Traduction de la sortie de schtasks en fran�ais
# Bas� sur check_mk 1.2.4 - 
# Valid� en Windows 2003 32 bits + Powerhsell 2.0
# Valid� en Windows 2008 R2
echo "<<<windows_tasks:sep(58)>>>"
$tasks = schtasks /query /fo csv -v
$tasks = $tasks -replace "Nom de la t�che","TaskName"
$tasks = $tasks -replace "Nom de l'h�te","HostName"
$tasks = $tasks -replace "Heure de la derni�re ex�cution","Last Run Time"
$tasks = $tasks -replace "Prochaine ex�cution","Next Run Time"
$tasks = $tasks -replace "Dernier r�sultat","Last Result"
$tasks = $tasks -replace "Statut de la t�che planifi�e","Scheduled Task State"
$tasks = $tasks -replace "D�sactiv�e","Disabled"
$tasks = $tasks -replace "Activ�e","Enabled"

$tasks | ConvertFrom-Csv  | ? {$_.HostName -match "^$($Env:Computername)$" -and $_.taskname -notlike '\Microsoft*'} | fl taskname,"last run time","next run time","last result","scheduled task state"
